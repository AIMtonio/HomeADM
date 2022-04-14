/**
 * IConsultaCFDIService.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tesoreria.serviciosWeb;

import java.rmi.RemoteException;

import tesoreria.bean.Acuse;

public interface IConsultaCFDIService extends java.rmi.Remote {
    public Acuse consulta(String expresionImpresa) throws RemoteException;
}
