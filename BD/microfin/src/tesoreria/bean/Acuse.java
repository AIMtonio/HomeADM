/**
 * Acuse.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tesoreria.bean;

import java.io.Serializable;

import org.apache.axis.description.ElementDesc;
import org.apache.axis.description.TypeDesc;
import org.apache.axis.encoding.Serializer;
import org.apache.axis.encoding.ser.BeanDeserializer;
import org.apache.axis.encoding.ser.BeanSerializer;

import javax.xml.namespace.QName;
import javax.xml.rpc.encoding.Deserializer;
public class Acuse  implements Serializable {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String codigoEstatus;

    private String esCancelable;

    private String estado;

    private String estatusCancelacion;

    public Acuse() {
    }

    public Acuse(
           String codigoEstatus,
           String esCancelable,
           String estado,
           String estatusCancelacion) {
           this.codigoEstatus = codigoEstatus;
           this.esCancelable = esCancelable;
           this.estado = estado;
           this.estatusCancelacion = estatusCancelacion;
    }


    /**
     * Gets the codigoEstatus value for this Acuse.
     * 
     * @return codigoEstatus
     */
    public String getCodigoEstatus() {
        return codigoEstatus;
    }


    /**
     * Sets the codigoEstatus value for this Acuse.
     * 
     * @param codigoEstatus
     */
    public void setCodigoEstatus(String codigoEstatus) {
        this.codigoEstatus = codigoEstatus;
    }


    /**
     * Gets the esCancelable value for this Acuse.
     * 
     * @return esCancelable
     */
    public String getEsCancelable() {
        return esCancelable;
    }


    /**
     * Sets the esCancelable value for this Acuse.
     * 
     * @param esCancelable
     */
    public void setEsCancelable(String esCancelable) {
        this.esCancelable = esCancelable;
    }


    /**
     * Gets the estado value for this Acuse.
     * 
     * @return estado
     */
    public String getEstado() {
        return estado;
    }


    /**
     * Sets the estado value for this Acuse.
     * 
     * @param estado
     */
    public void setEstado(String estado) {
        this.estado = estado;
    }


    /**
     * Gets the estatusCancelacion value for this Acuse.
     * 
     * @return estatusCancelacion
     */
    public String getEstatusCancelacion() {
        return estatusCancelacion;
    }


    /**
     * Sets the estatusCancelacion value for this Acuse.
     * 
     * @param estatusCancelacion
     */
    public void setEstatusCancelacion(String estatusCancelacion) {
        this.estatusCancelacion = estatusCancelacion;
    }

    private Object __equalsCalc = null;
    public synchronized boolean equals(Object obj) {
        if (!(obj instanceof Acuse)) return false;
        Acuse other = (Acuse) obj;
        if (obj == null) return false;
        if (this == obj) return true;
        if (__equalsCalc != null) {
            return (__equalsCalc == obj);
        }
        __equalsCalc = obj;
        boolean _equals;
        _equals = true && 
            ((this.codigoEstatus==null && other.getCodigoEstatus()==null) || 
             (this.codigoEstatus!=null &&
              this.codigoEstatus.equals(other.getCodigoEstatus()))) &&
            ((this.esCancelable==null && other.getEsCancelable()==null) || 
             (this.esCancelable!=null &&
              this.esCancelable.equals(other.getEsCancelable()))) &&
            ((this.estado==null && other.getEstado()==null) || 
             (this.estado!=null &&
              this.estado.equals(other.getEstado()))) &&
            ((this.estatusCancelacion==null && other.getEstatusCancelacion()==null) || 
             (this.estatusCancelacion!=null &&
              this.estatusCancelacion.equals(other.getEstatusCancelacion())));
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
        if (getCodigoEstatus() != null) {
            _hashCode += getCodigoEstatus().hashCode();
        }
        if (getEsCancelable() != null) {
            _hashCode += getEsCancelable().hashCode();
        }
        if (getEstado() != null) {
            _hashCode += getEstado().hashCode();
        }
        if (getEstatusCancelacion() != null) {
            _hashCode += getEstatusCancelacion().hashCode();
        }
        __hashCodeCalc = false;
        return _hashCode;
    }

    // Type metadata
    private static TypeDesc typeDesc =
        new TypeDesc(Acuse.class, true);

    static {
        typeDesc.setXmlType(new QName("http://schemas.datacontract.org/2004/07/Sat.Cfdi.Negocio.ConsultaCfdi.Servicio", "Acuse"));
        ElementDesc elemField = new ElementDesc();
        elemField.setFieldName("codigoEstatus");
        elemField.setXmlName(new QName("http://schemas.datacontract.org/2004/07/Sat.Cfdi.Negocio.ConsultaCfdi.Servicio", "CodigoEstatus"));
        elemField.setXmlType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new ElementDesc();
        elemField.setFieldName("esCancelable");
        elemField.setXmlName(new QName("http://schemas.datacontract.org/2004/07/Sat.Cfdi.Negocio.ConsultaCfdi.Servicio", "EsCancelable"));
        elemField.setXmlType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new ElementDesc();
        elemField.setFieldName("estado");
        elemField.setXmlName(new QName("http://schemas.datacontract.org/2004/07/Sat.Cfdi.Negocio.ConsultaCfdi.Servicio", "Estado"));
        elemField.setXmlType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
        elemField = new ElementDesc();
        elemField.setFieldName("estatusCancelacion");
        elemField.setXmlName(new QName("http://schemas.datacontract.org/2004/07/Sat.Cfdi.Negocio.ConsultaCfdi.Servicio", "EstatusCancelacion"));
        elemField.setXmlType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        elemField.setMinOccurs(0);
        elemField.setNillable(true);
        typeDesc.addFieldDesc(elemField);
    }

    /**
     * Return type metadata object
     */
    public static TypeDesc getTypeDesc() {
        return typeDesc;
    }

    /**
     * Get Custom Serializer
     */
    public static Serializer getSerializer(
           java.lang.String mechType, 
           java.lang.Class _javaType,  
           javax.xml.namespace.QName _xmlType) {
        return 
          new  BeanSerializer(
            _javaType, _xmlType, typeDesc);
    }

    /**
     * Get Custom Deserializer
     */
    public static Deserializer getDeserializer(
           String mechType, 
           Class _javaType,  
           QName _xmlType) {
        return 
          new  BeanDeserializer(
            _javaType, _xmlType, typeDesc);
    }

}
