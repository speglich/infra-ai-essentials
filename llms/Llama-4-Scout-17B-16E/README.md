# LLAMA-4-SCOUT-17B-16E Deployment

This directory contains Kubernetes resources for deploying the **LLAMA-4-SCOUT-17B-16E** model using vLLM.

## 🚀 Recommended Configuration

### ⚡ **Optimal Configuration for BM.GPU.H100.8**
- **1 replica with 8 H100 GPUs** is the most efficient combination
- Uses `tensor_parallel_size=8` for optimized distribution
- Maximum resource utilization without multi-replica overhead

## 📋 Configuration Files

- `deployment.yaml` - Main deployment configuration
- `services.yaml` - Service exposure via NodePort
- `namespace.yaml` - Dedicated namespace for vLLM
- `secret.yaml` - Secret for Hugging Face token

## 🔧 Prerequisites

1. **Kubernetes Cluster** with GPU support
2. **Hugging Face Token** for model access
3. **NVIDIA GPU Operator** installed
4. **Bare Metal with BM.GPU.H100.8** (8x NVIDIA H100)

## 📦 Deployment

### 1. Create the namespace
```bash
kubectl apply -f namespace.yaml
```

### 2. Configure Hugging Face secret
```bash
# Edit secret.yaml with your token
kubectl apply -f secret.yaml
```

### 3. Deploy the model
```bash
kubectl apply -f deployment.yaml
kubectl apply -f services.yaml
```

### 4. Verify deployment
```bash
kubectl get pods -n vllm
kubectl logs -f deployment/scout -n vllm
```

## 🌐 Service Access

The service is exposed via **NodePort 32328**:
- URL: `http://<node-ip>:32328`
- OpenAI-compatible API at `/v1/` endpoint

### Test example
```bash
curl -X POST "http://<node-ip>:32328/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "meta-llama/Llama-4-Scout-17B-16E",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 100
  }'
```

## ⚙️ Technical Specifications

### Container Resources
- **GPUs**: 8x NVIDIA H100
- **Shared Memory**: 8GB
- **Hugging Face Cache**: Persistent at `/mnt/scratch/cache`

### vLLM Configuration
- **Tensor Parallelism**: 8 GPUs
- **Model**: meta-llama/Llama-4-Scout-17B-16E
- **API**: OpenAI Compatible

## 📊 Performance

### Optimized Configuration for BM.GPU.H100.8
- ✅ **1 replica + 8 GPUs**: Ideal configuration
- ✅ **Tensor Parallelism**: Efficient distribution across GPUs
- ✅ **Persistent Cache**: Avoids model re-download
- ✅ **Init Container**: Model pre-loading

### Advantages of this Configuration
1. **Minimal Latency**: No multi-replica overhead
2. **Maximum Throughput**: Full utilization of 8 H100 GPUs
3. **Memory Efficiency**: Optimized sharing between GPUs
4. **Scalability**: Easy resource adjustment as needed

## 🔍 Troubleshooting

### Check pod status
```bash
kubectl describe pod -l app=scout -n vllm
```

### Container logs
```bash
kubectl logs -f deployment/scout -n vllm -c scout
```

### Init container logs
```bash
kubectl logs deployment/scout -n vllm -c preload-model
```

### Check GPU resources
```bash
kubectl describe node <node-name>
```

## 📝 Important Notes

- **Startup Time**: First deployment may take several minutes due to model download
- **Cache**: Model is stored at `/mnt/scratch/cache` for reuse
- **HF Token**: Required to access the protected model on Hugging Face
- **Hardware**: Specifically optimized for BM.GPU.H100.8

## 🛠️ Customization

To adjust the configuration, edit `deployment.yaml`:
- **Change GPUs**: Modify `tensor_parallel_size` and `nvidia.com/gpu`
- **Change model**: Alter the `--model` argument
- **Adjust memory**: Modify `sizeLimit` of cache volume

---
*This deployment has been optimized for maximum performance on BM.GPU.H100.8 hardware*