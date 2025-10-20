#!/bin/bash
 
# Script to configure GKE cluster access and setup namespace
 
# Set the GCP project
gcloud config set project "madrid-pgoum-des"
# List container clusters
gcloud container clusters list
# Get credentials for the GKE cluster
gcloud container clusters get-credentials gke-eusw1-des-pgoum-carto-01 --region europe-southwest1
# Create namespace in Kubernetes
kubectl create namespace carto-pgoum
kubectl create secret generic carto-postgresql --from-literal=user-password="Carto-2025" -n carto-pgoum
kubectl create serviceaccount carto-common-backend -n carto-pgoum
# Preflight Carto
helm template carto carto/carto -f carto-values.yaml -f carto-secrets.yaml -f customizations.yaml -n 'carto-pgoum' | kubectl preflight -
# Install Carto
kubectl delete serviceaccount carto-common-backend -n carto-pgoum
helm install carto carto/carto -f carto-values.yaml -f carto-secrets.yaml -f customizations.yaml -n 'carto-pgoum'
# Get Pods Carto
kubectl get pods -n carto-pgoum