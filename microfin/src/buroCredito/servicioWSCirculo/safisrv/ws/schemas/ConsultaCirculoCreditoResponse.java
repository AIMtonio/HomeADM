/**
 * ConsultaCirculoCreditoResponse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package buroCredito.servicioWSCirculo.safisrv.ws.schemas;

public class ConsultaCirculoCreditoResponse  implements java.io.Serializable {
    private java.lang.String numMensaje;

    private java.lang.String mensajeRespuesta;

    private java.lang.String folioSolicitudConsulta;

    public ConsultaCirculoCreditoResponse() {
    }

    public ConsultaCirculoCreditoResponse(
           java.lang.String numMensaje,
           java.lang.String mensajeRespuesta,
           java.lang.String folioSolicitudConsulta) {
           this.numMensaje = numMensaje;
           this.mensajeRespuesta = mensajeRespuesta;
           this.folioSolicitudConsulta = folioSolicitudConsulta;
    }


    /**
     * Gets the numMensaje value for this ConsultaCirculoCreditoResponse.
     * 
     * @return numMensaje
     */
    public java.lang.String getNumMensaje() {
        return numMensaje;
    }


    /**
     * Sets the numMensaje value for this ConsultaCirculoCreditoResponse.
     * 
     * @param numMensaje
     */
    public void setNumMensaje(java.lang.String numMensaje) {
        this.numMensaje = numMensaje;
    }


    /**
     * Gets the mensajeRespuesta value for this ConsultaCirculoCreditoResponse.
     * 
     * @return mensajeRespuesta
     */
    public java.lang.String getMensajeRespuesta() {
        return mensajeRespuesta;
    }


    /**
     * Sets the mensajeRespuesta value for this ConsultaCirculoCreditoResponse.
     * 
     * @param mensajeRespuesta
     */
    public void setMensajeRespuesta(java.lang.String mensajeRespuesta) {
        this.mensajeRespuesta = mensajeRespuesta;
    }


    /**
     * Gets the folioSolicitudConsulta value for this ConsultaCirculoCreditoResponse.
     * 
     * @return folioSolicitudConsulta
     */
    public java.lang.String getFolioSolicitudConsulta() {
        return folioSolicitudConsulta;
    }


    /**
     * Sets the folioSolicitudConsulta value for this ConsultaCirculoCreditoResponse.
     * 
     * @param folioSolicitudConsulta
     */
    public void setFolioSolicitudConsulta(java.lang.String folioSolicitudConsulta) {
        this.folioSolicitudConsulta = folioSolicitudConsulta;
    }

    private java.lang.Object __equalsCalc = null;
    public synchronized boolean equals(java.lang.Object obj) {
        if (!(obj instanceof ConsultaCirculoCreditoResponse)) return false;
        ConsultaCirculoCreditoResponse other = (ConsultaCirculoCreditoResponse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.numMensaje==null && other.getNumMensaje()==null) || 
             (this.numMensaje!=null &&
              this.numMensaje.equals(other.getNumMensaje()))) &&
            ((this.mensajeRespuesta==null && other.getMensajeRespuesta()==null) || 
             (this.mensajeRespuesta!=null &&
              this.mensajeRespuesta.equals(other.getMensajeRespuesta()))) &&
            ((this.folioSolicitudConsulta==null && other.getFolioSolicitudConsulta()==null) || 
             (this.folioSolicitudConsulta!=null &&
              this.folioSolicitudConsulta.equals(other.getFolioSolicitudConsulta())));
        __equalsCalc = null;
        return _equals;
    }

    private boolean __hashCodeCalc = false;
    public synchronized int hashCode() {
        if (__hashCodeCalc) {
            return 0;
        }
        __hashCodeCalc = true;
        int _hashCode = 1;
        if (getNumMensaje() != null) {
            _hashCode += getNumMensaje().hashCode();
        }
        if (getMensajeRespuesta() != null) {
            _hashCode += getMensajeRespuesta().hashCode();
        }
        if (getFolioSolicitudConsulta() != null) {
            _hashCode += getFolioSolicitudConsulta().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static org.apache.axis.description.TypeDesc typeDesc =
        new org.apache.axis.description.TypeDesc(ConsultaCirculoCreditoResponse.class, true);

    static {
        typeDesc.setXmlType(new javax.xml.namespace.QName("http://safisrv/ws/schemas", ">consultaCirculoCreditoResponse"));
        org.apache.axis.description.ElementDesc elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("numMensaje");
        elemField.setXmlName(new javax.xml.namespace.QName("http://safisrv/ws/schemas", "numMensaje"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("mensajeRespuesta");
        elemField.setXmlName(new javax.xml.namespace.QName("http://safisrv/ws/schemas", "mensajeRespuesta"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
        elemField = new org.apache.axis.description.ElementDesc();
        elemField.setFieldName("folioSolicitudConsulta");
        elemField.setXmlName(new javax.xml.namespace.QName("http://safisrv/ws/schemas", "folioSolicitudConsulta"));
        elemField.setXmlType(new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setNillable(false);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static org.apache.axis.description.TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static org.apache.axis.encoding.Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static org.apache.axis.encoding.Deserializer getDeserializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  org.apache.axis.encoding.ser.BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
