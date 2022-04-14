/**
 * SAFIServiciosServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package buroCredito.servicioWSCirculo.safisrv.ws.schemas;

import soporte.PropiedadesSAFIBean;

public class SAFIServiciosServiceLocator extends org.apache.axis.client.Service implements buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosService {

    public SAFIServiciosServiceLocator() {
    }


    public SAFIServiciosServiceLocator(org.apache.axis.EngineConfiguration config) {
        super(config);
    }

    public SAFIServiciosServiceLocator(java.lang.String wsdlLoc, javax.xml.namespace.QName sName) throws javax.xml.rpc.ServiceException {
        super(wsdlLoc, sName);
    }

    // Use to get a proxy class for SAFIServiciosSoap11
    String direccionEndPointCirculoCreditoWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("direccionEndPointCirculoCreditoWS");
    private java.lang.String SAFIServiciosSoap11_address = direccionEndPointCirculoCreditoWS+ ",";

    public java.lang.String getSAFIServiciosSoap11Address() {
        return SAFIServiciosSoap11_address;
    }

    // The WSDD service name defaults to the port name.
    private java.lang.String SAFIServiciosSoap11WSDDServiceName = "SAFIServiciosSoap11";

    public java.lang.String getSAFIServiciosSoap11WSDDServiceName() {
        return SAFIServiciosSoap11WSDDServiceName;
    }

    public void setSAFIServiciosSoap11WSDDServiceName(java.lang.String name) {
        SAFIServiciosSoap11WSDDServiceName = name;
    }

    public buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios getSAFIServiciosSoap11() throws javax.xml.rpc.ServiceException {
       java.net.URL endpoint;
        try {
            endpoint = new java.net.URL(SAFIServiciosSoap11_address);
        }
        catch (java.net.MalformedURLException e) {
            throw new javax.xml.rpc.ServiceException(e);
        }
        return getSAFIServiciosSoap11(endpoint);
    }

    public buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios getSAFIServiciosSoap11(java.net.URL portAddress) throws javax.xml.rpc.ServiceException {
        try {
            buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosSoap11Stub _stub = new buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosSoap11Stub(portAddress, this);
            _stub.setPortName(getSAFIServiciosSoap11WSDDServiceName());
            return _stub;
        }
        catch (org.apache.axis.AxisFault e) {
            return null;
        }
    }

    public void setSAFIServiciosSoap11EndpointAddress(java.lang.String address) {
        SAFIServiciosSoap11_address = address;
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        try {
            if (buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServicios.class.isAssignableFrom(serviceEndpointInterface)) {
                buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosSoap11Stub _stub = new buroCredito.servicioWSCirculo.safisrv.ws.schemas.SAFIServiciosSoap11Stub(new java.net.URL(SAFIServiciosSoap11_address), this);
                _stub.setPortName(getSAFIServiciosSoap11WSDDServiceName());
                return _stub;
            }
        }
        catch (java.lang.Throwable t) {
            throw new javax.xml.rpc.ServiceException(t);
        }
        throw new javax.xml.rpc.ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    /**
     * For the given interface, get the stub implementation.
     * If this service has no port for the given interface,
     * then ServiceException is thrown.
     */
    public java.rmi.Remote getPort(javax.xml.namespace.QName portName, Class serviceEndpointInterface) throws javax.xml.rpc.ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        java.lang.String inputPortName = portName.getLocalPart();
        if ("SAFIServiciosSoap11".equals(inputPortName)) {
            return getSAFIServiciosSoap11();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((org.apache.axis.client.Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public javax.xml.namespace.QName getServiceName() {
        return new javax.xml.namespace.QName("http://safisrv/ws/schemas", "SAFIServiciosService");
    }

    private java.util.HashSet ports = null;

    public java.util.Iterator getPorts() {
        if (ports == null) {
            ports = new java.util.HashSet();
            ports.add(new javax.xml.namespace.QName("http://safisrv/ws/schemas", "SAFIServiciosSoap11"));
        }
        return ports.iterator();
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(java.lang.String portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        
if ("SAFIServiciosSoap11".equals(portName)) {
            setSAFIServiciosSoap11EndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new javax.xml.rpc.ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }

    /**
    * Set the endpoint address for the specified port name.
    */
    public void setEndpointAddress(javax.xml.namespace.QName portName, java.lang.String address) throws javax.xml.rpc.ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
