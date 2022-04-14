/**
 * Service1Soap.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package spei.servicioweb;

public interface Service1Soap extends java.rmi.Remote {
    public java.lang.String contrataciones(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String info(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String logs(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String devolucion(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String notificaciones(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String reportaPago(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String reverso(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
    public java.lang.String generaClave(java.lang.String cadena, java.lang.String datos, java.lang.String corresponsales, java.lang.String ruta_ejecutar) throws java.rmi.RemoteException;
}
