{{- define "httproute.filters" }}
filters:
- type: {{ .Values.httproute.type }}
  urlRewrite:
    path:
      type: {{ .Values.httproute.filter.urlRewrite.type }}
      replacePrefixMatch: {{ .Values.httproute.filter.urlRewrite.replacePrefixMatch }}
{{- end }}