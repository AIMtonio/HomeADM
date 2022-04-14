/**
 * WsRelacionClienteTarjetaServiceLocator.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tarjetas.servicio;

import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.Remote;
import java.util.HashSet;
import java.util.Iterator;

import javax.xml.namespace.QName;
import javax.xml.rpc.ServiceException;

import org.apache.axis.AxisFault;
import org.apache.axis.EngineConfiguration;
import org.apache.axis.client.Service;
import org.apache.axis.client.Stub;

public class WsRelacionClienteTarjetaServiceLocator extends Service implements WsRelacionClienteTarjetaService {

    public WsRelacionClienteTarjetaServiceLocator() {
    }

    public WsRelacionClienteTarjetaServiceLocator(EngineConfiguration config) {
        super(config);
    }

    public WsRelacionClienteTarjetaServiceLocator(String wsdlLoc, QName sName) throws ServiceException {
        super(wsdlLoc, sName);
    }

    private String wsRelacionClienteTarjetaPort_address = "http://WIN-AIC26Q3VGNU:8080/SWITCH_ENTURA/wsRelacionClienteTarjeta";

    public String getwsRelacionClienteTarjetaPortAddress() {
        return wsRelacionClienteTarjetaPort_address;
    }

    private String wsRelacionClienteTarjetaPortWSDDServiceName = "wsRelacionClienteTarjetaPort";

    public String getwsRelacionClienteTarjetaPortWSDDServiceName() {
        return wsRelacionClienteTarjetaPortWSDDServiceName;
    }

    public void setwsRelacionClienteTarjetaPortWSDDServiceName(String name) {
        wsRelacionClienteTarjetaPortWSDDServiceName = name;
    }

    public WsRelacionClienteTarjeta getwsRelacionClienteTarjetaPort() throws ServiceException {
       URL endpoint;
        try {
            endpoint = new URL(wsRelacionClienteTarjetaPort_address);
        }
        catch (MalformedURLException e) {
            throw new ServiceException(e);
        }
        return getwsRelacionClienteTarjetaPort(endpoint);
    }

    public WsRelacionClienteTarjeta getwsRelacionClienteTarjetaPort(URL portAddress) throws ServiceException {
        try {
        	WsRelacionClienteTarjetaServiceSoapBindingStub _stub = new WsRelacionClienteTarjetaServiceSoapBindingStub(portAddress, this);
            _stub.setPortName(getwsRelacionClienteTarjetaPortWSDDServiceName());
            return _stub;
        }
        catch (AxisFault e) {
            return null;
        }
    }

    public void setwsRelacionClienteTarjetaPortEndpointAddress(String address) {
        wsRelacionClienteTarjetaPort_address = address;
    }


    public Remote getPort(Class serviceEndpointInterface) throws ServiceException {
        try {
            if (WsRelacionClienteTarjeta.class.isAssignableFrom(serviceEndpointInterface)) {
            	WsRelacionClienteTarjetaServiceSoapBindingStub _stub = new WsRelacionClienteTarjetaServiceSoapBindingStub(new URL(wsRelacionClienteTarjetaPort_address), this);
                _stub.setPortName(getwsRelacionClienteTarjetaPortWSDDServiceName());
                return _stub;
            }
        }
        catch (Throwable t) {
            throw new ServiceException(t);
        }
        throw new ServiceException("There is no stub implementation for the interface:  " + (serviceEndpointInterface == null ? "null" : serviceEndpointInterface.getName()));
    }

    public Remote getPort(QName portName, Class serviceEndpointInterface) throws ServiceException {
        if (portName == null) {
            return getPort(serviceEndpointInterface);
        }
        String inputPortName = portName.getLocalPart();
        if ("wsRelacionClienteTarjetaPort".equals(inputPortName)) {
            return getwsRelacionClienteTarjetaPort();
        }
        else  {
            java.rmi.Remote _stub = getPort(serviceEndpointInterface);
            ((Stub) _stub).setPortName(portName);
            return _stub;
        }
    }

    public QName getServiceName() {
        return new QName("http://ws/", "wsRelacionClienteTarjetaService");
    }

    private HashSet ports = null;

    public Iterator getPorts() {
        if (ports == null) {
            ports = new HashSet();
            ports.add(new QName("http://ws/", "wsRelacionClienteTarjetaPort"));
        }
        return ports.iterator();
    }


    public void setEndpointAddress(String portName, String address) throws ServiceException {
        
if ("wsRelacionClienteTarjetaPort".equals(portName)) {
            setwsRelacionClienteTarjetaPortEndpointAddress(address);
        }
        else 
{ // Unknown Port Name
            throw new ServiceException(" Cannot set Endpoint Address for Unknown Port" + portName);
        }
    }


    public void setEndpointAddress(QName portName,String address) throws ServiceException {
        setEndpointAddress(portName.getLocalPart(), address);
    }

}
