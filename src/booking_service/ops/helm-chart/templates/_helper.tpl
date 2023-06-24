{{- define "httproute.filters" -}}
      filters:
      - type: {{ .Values.httproute.filters.type }}
        urlRewrite:
          path:
            type: {{ .Values.httproute.filters.urlRewrite.type }}
            replacePrefixMatch: {{ .Values.httproute.filters.urlRewrite.replacePrefixMatch }}
{{- end -}}