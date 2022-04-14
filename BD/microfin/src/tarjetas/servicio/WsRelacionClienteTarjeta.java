/**
 * WsRelacionClienteTarjeta.java
 *
 * This file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 */

package tarjetas.servicio;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface WsRelacionClienteTarjeta extends Remote {
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
    									 String indicadorCuenta) throws RemoteException;
    public String anulacionClienteTarjeta(String codigoCooperativa,
    									  String codigoUsuario,
    									  String ipTerminal,
    									  String numeroDocumento,
    									  String numeroTarjeta) throws RemoteException;
}
