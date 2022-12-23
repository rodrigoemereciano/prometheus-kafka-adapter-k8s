## Laboratory for validating prometheus-kafka-adapter k8s manifests:
</br>

### The Stack with these components:

- Prometheus
- Prometheus-kafka-adapter
- Zookeeper
- Kafka

</br>

### Architecture:

prometheus &#8594; prometheus-kafka-adapter &#8594; kafka

Observation: I'm using metal-lb load balancer as a service and kind for creation cluster local
