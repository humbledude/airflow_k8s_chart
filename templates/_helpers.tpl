{{- define "helper.github.url" -}}
https://{{ .Values.github.username }}:{{ .Values.github.token }}@{{ .Values.github.repo | replace "https://" "" }}
{{- end -}}

{{- define "helper.webserver.url" -}}
http://{{ .Values.ingress.host }}
{{- end -}}

{{- define "helper.dir.dags-repo" -}}
{{ .Values.airflow_home }}/dags
{{- end -}}

{{- define "helper.dir.logs" -}}
{{ .Values.airflow_home }}/logs
{{- end -}}


{{- define "helper.container.env" -}}
env:
- name: AIRFLOW_HOME
  value: {{ .Values.airflow_home }}
- name: AIRFLOW_KUBE_NAMESPACE
  valueFrom:
    fieldRef:
      fieldPath: metadata.namespace
- name: SQL_ALCHEMY_CONN
  valueFrom:
    secretKeyRef:
      name: {{ .Values.db_secret.name }}
      key: {{ .Values.db_secret.key }}
- name: FERNET_KEY
  value: {{ .Values.airflow_config_env.core.fernet_key }}
envFrom:
- configMapRef:
    name: {{ .Values.airflow_config_env.kubernetes.env_from_configmap_ref }}
{{- end -}}

{{- define "helper.container.volumeMounts.common" -}}
volumeMounts:
- name: airflow-dags
  mountPath: {{ include "helper.dir.dags-repo" . }}
{{- end -}}


