/**
 * WsRelacionClienteTarjetaServiceSoapBindingStub.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tarjetas.servicio;

import java.net.URL;
import java.rmi.RemoteException;
import java.util.Enumeration;
import java.util.Vector;

import javax.xml.namespace.QName;
import javax.xml.rpc.Service;

import org.apache.axis.AxisEngine;
import org.apache.axis.AxisFault;
import org.apache.axis.NoEndPointException;
import org.apache.axis.client.Call;
import org.apache.axis.client.Stub;
import org.apache.axis.constants.Style;
import org.apache.axis.constants.Use;
import org.apache.axis.description.OperationDesc;
import org.apache.axis.description.ParameterDesc;
import org.apache.axis.soap.SOAPConstants;
import org.apache.axis.utils.JavaUtils;

public class WsRelacionClienteTarjetaServiceSoapBindingStub extends Stub implements WsRelacionClienteTarjeta {
    private Vector cachedSerClasses = new Vector();
    private Vector cachedSerQNames = new Vector();
    private Vector cachedSerFactories = new Vector();
    private Vector cachedDeserFactories = new Vector();

    static OperationDesc [] _operations;

    static {
        _operations = new OperationDesc[2];
        _initOperationDesc1();
    }

    private static void _initOperationDesc1(){
        OperationDesc oper;
        ParameterDesc param;
        oper = new OperationDesc();
        oper.setName("relacionClienteTarjeta");
        param = new ParameterDesc(new QName("", "codigoCooperativa"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"),String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "codigoUsuario"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"),String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "ipTerminal"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "numeroDocumento"),ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "tipoDocumento"), ParameterDesc.IN, 
        		new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "int"), int.class, false, false);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "nombresCliente"), ParameterDesc.IN, 
        		new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), 
        		String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "apellidosCliente"), ParameterDesc.IN, 
        		new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), 
        		String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "numeroCuenta"), ParameterDesc.IN, 
        		new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), 
        		String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "tipoCuenta"), ParameterDesc.IN, 
        		new javax.xml.namespace.QName("http://www.w3.org/2001/XMLSchema", "string"), 
        		String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "codigoMonedaCuenta"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "direccionCliente"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "tipoDireccion"), ParameterDesc.IN,
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "correoCliente"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "telefonoCliente"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "tipoTelefono"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "numeroTarjeta"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "estadoCivil"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "genero"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "fechaNacimiento"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "indicadorCuenta"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(String.class);
        oper.setReturnQName(new QName("", "return"));
        oper.setStyle(Style.WRAPPED);
        oper.setUse(Use.LITERAL);
        _operations[0] = oper;

        oper = new OperationDesc();
        oper.setName("AnulacionClienteTarjeta");
        param = new ParameterDesc(new QName("", "codigoCooperativa"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "codigoUsuario"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "ipTerminal"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "numeroDocumento"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        param = new ParameterDesc(new QName("", "numeroTarjeta"), ParameterDesc.IN, 
        		new QName("http://www.w3.org/2001/XMLSchema", "string"), String.class, false, false);
        param.setOmittable(true);
        oper.addParameter(param);
        oper.setReturnType(new QName("http://www.w3.org/2001/XMLSchema", "string"));
        oper.setReturnClass(String.class);
        oper.setReturnQName(new QName("", "return"));
        oper.setStyle(Style.WRAPPED);
        oper.setUse(Use.LITERAL);
        _operations[1] = oper;

    }

    public WsRelacionClienteTarjetaServiceSoapBindingStub() throws AxisFault {
         this(null);
    }

    public WsRelacionClienteTarjetaServiceSoapBindingStub(URL endpointURL,Service service) throws AxisFault {
         this(service);
         super.cachedEndpoint = endpointURL;
    }

    public WsRelacionClienteTarjetaServiceSoapBindingStub(Service service) throws AxisFault {
        if (service == null) {
            super.service = new org.apache.axis.client.Service();
        } else {
            super.service = service;
        }
        ((org.apache.axis.client.Service)super.service).setTypeMappingVersion("1.2");
    }

    protected Call createCall() throws RemoteException {
        try {
            Call _call = super._createCall();
            if (super.maintainSessionSet) {
                _call.setMaintainSession(super.maintainSession);
            }
            if (super.cachedUsername != null) {
                _call.setUsername(super.cachedUsername);
            }
            if (super.cachedPassword != null) {
                _call.setPassword(super.cachedPassword);
            }
            if (super.cachedEndpoint != null) {
                _call.setTargetEndpointAddress(super.cachedEndpoint);
            }
            if (super.cachedTimeout != null) {
                _call.setTimeout(super.cachedTimeout);
            }
            if (super.cachedPortName != null) {
                _call.setPortName(super.cachedPortName);
            }
            Enumeration keys = super.cachedProperties.keys();
            while (keys.hasMoreElements()) {
                String key = (String) keys.nextElement();
                _call.setProperty(key, super.cachedProperties.get(key));
            }
            return _call;
        }
        catch (Throwable _t) {
            throw new AxisFault("Failure trying to get the Call object", _t);
        }
    }

    public String relacionClienteTarjeta(String codigoCooperativa,
    									 String codigoUsuario,
    									 String ipTerminal,
    									 String numeroDocumento,
    									 int tipoDocumento,
    									 String nombresCliente,
    									 String apellidosCliente,
    									 String numeroCuenta,
    									 String tipoCuenta,
    									 String codigoMonedaCuenta,
    									 String direccionCliente,
    									 String tipoDireccion,
    									 String correoCliente,
    									 String telefonoCliente,
    									 String tipoTelefono,
    									 String numeroTarjeta,
    									 String estadoCivil,
    									 String genero,
    									 String fechaNacimiento,
    									 String indicadorCuenta) throws RemoteException {
        if (super.cachedEndpoint == null) {
            throw new NoEndPointException();
        }
        Call _call = createCall();
        _call.setOperation(_operations[0]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("vincularClienteTarjeta");
        _call.setEncodingStyle(null);
        _call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new QName("http://ws/", "relacionClienteTarjeta"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {        Object _resp = _call.invoke(new Object[] {codigoCooperativa,
		 									codigoUsuario, ipTerminal, numeroDocumento,
 											new Integer(tipoDocumento), nombresCliente,
 											apellidosCliente, numeroCuenta, tipoCuenta,
 											codigoMonedaCuenta, direccionCliente, tipoDireccion,
 											correoCliente, telefonoCliente, tipoTelefono,
 											numeroTarjeta, estadoCivil, genero, fechaNacimiento,
 											indicadorCuenta});

        if (_resp instanceof RemoteException) {
            throw (RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (String) _resp;
            } catch (Exception _exception) {
                return (String) JavaUtils.convert(_resp, String.class);
            }
        }
  } catch (AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

    public String anulacionClienteTarjeta(String codigoCooperativa,String codigoUsuario,
    									  String ipTerminal, String numeroDocumento,
    									  String numeroTarjeta) throws RemoteException {
        if (super.cachedEndpoint == null) {
            throw new NoEndPointException();
        }
        Call _call = createCall();
        _call.setOperation(_operations[1]);
        _call.setUseSOAPAction(true);
        _call.setSOAPActionURI("anularClienteTarjeta");
        _call.setEncodingStyle(null);
        _call.setProperty(Call.SEND_TYPE_ATTR, Boolean.FALSE);
        _call.setProperty(AxisEngine.PROP_DOMULTIREFS, Boolean.FALSE);
        _call.setSOAPVersion(SOAPConstants.SOAP11_CONSTANTS);
        _call.setOperationName(new QName("http://ws/", "AnulacionClienteTarjeta"));

        setRequestHeaders(_call);
        setAttachments(_call);
 try {       	Object _resp = _call.invoke(new Object[] {codigoCooperativa, codigoUsuario,
		 									ipTerminal, numeroDocumento, numeroTarjeta});

        if (_resp instanceof RemoteException) {
            throw (RemoteException)_resp;
        }
        else {
            extractAttachments(_call);
            try {
                return (String) _resp;
            } catch (Exception _exception) {
                return (String) JavaUtils.convert(_resp,String.class);
            }
        }
  } catch (AxisFault axisFaultException) {
  throw axisFaultException;
}
    }

}
