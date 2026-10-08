{{- /* Chart name  */ -}}
{{- define "payment-api.name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /* Full name used as prefix */ -}}
{{- define "payment-api.fullname" -}}
{{- printf "%s-%s-api" .Release.Name (include "payment-api.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "payment-api.labels" -}}
app.kubernetes.io/name: {{ include "payment-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: api
env: {{ .Values.environment }}
{{- end -}}

{{- define "payment-api.selector" -}}
app.kubernetes.io/name: {{ include "payment-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: api
{{- end -}}

{{- define "payment-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.name -}}
{{- .Values.serviceAccount.name -}}
{{- else -}}
{{- printf "%s-sa" (include "payment-api.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
