/**
 * WsRelacionClienteTarjetaService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tarjetas.servicio;

import java.net.URL;

import javax.xml.rpc.Service;
import javax.xml.rpc.ServiceException;

public interface WsRelacionClienteTarjetaService extends Service {
    public String getwsRelacionClienteTarjetaPortAddress();

    public WsRelacionClienteTarjeta getwsRelacionClienteTarjetaPort() throws ServiceException;

    public WsRelacionClienteTarjeta getwsRelacionClienteTarjetaPort(URL portAddress) throws ServiceException;
}
