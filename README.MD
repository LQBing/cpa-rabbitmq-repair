# Custom Pod Autoscaler for Repair Worker with Rabbitmq

The project extends from project [custom-pod-autoscaler](https://github.com/jthomperoo/custom-pod-autoscaler)

This project is a Custom Pod Autoscaler (CPA) using Golang.

The project extends the Alpine CPA base image (custompodautoscaler/alpine) and adds in a Golang binary to execute for gathering metrics/making evaluations.

## Overview

This CPA contains a docker image of rabbitmq repair cpa, alongside using the `metric` from [prometheus-rabbitmq-exporter](https://artifacthub.io/packages/helm/prometheus-worawutchan/prometheus-rabbitmq-exporter) or other `metric` monitoring rabbitmq message count as a target to scale up and down.

The CPA autoscales the pod count with the following rabbitmq queue message count.

### Parameters of Custom Pod Autoscaler

<!-- The CPA will get `targetReplicas` from the `metric` in `prometheus-rabbitmq-exporter` with annotation `repair.rabbitmq.cpa.lqbing.com/metric-url` like "http://prometheus-rabbitmq-exporter:9419". (Required) -->

The CPA will get `queue-name` with annotation `repair.rabbitmq.cpa.lqbing.com/queue-name`. (Required)

The CPA will get `replicas-per-message` with annotation `repair.rabbitmq.cpa.lqbing.com/replicas-per-message`.

The CPA `maxReplicas` & `minReplicas` set in config.yaml

The CPA exposes two endpoints:

* `GET /metrics`
  * Displays queue message count value and min replica value and max replica value from rabbitmq metrics along with `metric-url` and `queue-name`.
  * Aliased with `metrics` in the Dockerfile.
* `GET /evaluation`
  * Displays the evaluation decision made on how to scale, reporting the `targetReplicas` - how many of the specified rabbitmq message count exist.
  * Aliased with `evaluation` in the Dockerfile.

## Usage

Trying out this example requires a kubernetes cluster to try it out on, this guide will assume you are using Minikube.

### Enable CPAs

Using this CPA requires CPAs to be enabled on your kubernetes cluster, [follow this guide to set up CPAs on your cluster](https://github.com/jthomperoo/custom-pod-autoscaler-operator#installation).

### Switch to target the Minikube registry

Target the Minikube registry for building the image:
`eval $(minikube docker-env)`

### Deploy an app for the CPA to manage

You need to deploy an app for the CPA to manage, such as an simple nginx or toybox deployment.

### Deploy prometheus-rabbitmq-exporter

Follow steps with [prometheus-rabbitmq-exporter](https://artifacthub.io/packages/helm/prometheus-worawutchan/prometheus-rabbitmq-exporter)

### Build CPA image

Once CPAs have been enabled on your cluster, you need to build this example, run these commands to build the example:

* Use the Makefile to build the docker image
`make docker`
* Deploy the CPA using the image just built.
`kubectl apply -f cpa.yaml`
Now the CPA should be running on your cluster, managing the app we previously deployed.

## Testing the CPA

* List pods.
`kubectl get pods`
* Exec into a pod.
`kubectl exec -it POD_NAME bash`
* Get value.
`metric`
