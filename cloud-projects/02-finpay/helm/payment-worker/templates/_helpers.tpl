{{- /* Chart name  */ -}}
{{- define "payment-worker.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /* Full name used as prefix */ -}}
{{- define "payment-worker.fullname" -}}
{{- printf "%s-%s-worker" .Release.Name (include "payment-worker.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "payment-worker.labels" -}}
app.kubernetes.io/name: {{ include "payment-worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
env: {{ .Values.environment }}
{{- end -}}

{{- define "payment-worker.selector" -}}
app.kubernetes.io/name: {{ include "payment-worker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
