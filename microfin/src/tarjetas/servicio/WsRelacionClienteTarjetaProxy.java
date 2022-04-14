package tarjetas.servicio;

import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;
import javax.xml.rpc.Stub;

public class WsRelacionClienteTarjetaProxy implements WsRelacionClienteTarjeta {
  private String _endpoint = null;
  private WsRelacionClienteTarjeta wsRelacionClienteTarjeta = null;
  
  public WsRelacionClienteTarjetaProxy() {
    _initWsRelacionClienteTarjetaProxy();
  }
  
  public WsRelacionClienteTarjetaProxy(String endpoint) {
    _endpoint = endpoint;
    _initWsRelacionClienteTarjetaProxy();
  }
  
  private void _initWsRelacionClienteTarjetaProxy() {
    try {
      wsRelacionClienteTarjeta = (new WsRelacionClienteTarjetaServiceLocator()).getwsRelacionClienteTarjetaPort();
      if (wsRelacionClienteTarjeta != null) {
        if (_endpoint != null)
          ((Stub)wsRelacionClienteTarjeta)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
        else
          _endpoint = (String)((Stub)wsRelacionClienteTarjeta)._getProperty("javax.xml.rpc.service.endpoint.address");
      }
      
    }
    catch (ServiceException serviceException) {}
  }
  
  public String getEndpoint() {
    return _endpoint;
  }
  
  public void setEndpoint(String endpoint) {
    _endpoint = endpoint;
    if (wsRelacionClienteTarjeta != null)
      ((Stub)wsRelacionClienteTarjeta)._setProperty("javax.xml.rpc.service.endpoint.address", _endpoint);
    
  }
  
  public WsRelacionClienteTarjeta getWsRelacionClienteTarjeta() {
    if (wsRelacionClienteTarjeta == null)
      _initWsRelacionClienteTarjetaProxy();
    return wsRelacionClienteTarjeta;
  }
  
  public String relacionClienteTarjeta(String codigoCooperativa, String codigoUsuario,String ipTerminal,
									  String numeroDocumento,int tipoDocumento,String nombresCliente,
									  String apellidosCliente,String numeroCuenta,String tipoCuenta,
									  String codigoMonedaCuenta,String direccionCliente,String tipoDireccion,
									  String correoCliente,String telefonoCliente,String tipoTelefono,
									  String numeroTarjeta,String estadoCivil,String genero,
									  String fechaNacimiento,String indicadorCuenta) throws RemoteException{
    if (wsRelacionClienteTarjeta == null)
      _initWsRelacionClienteTarjetaProxy();
    return wsRelacionClienteTarjeta.relacionClienteTarjeta(codigoCooperativa, codigoUsuario, ipTerminal,
												    		numeroDocumento, tipoDocumento, nombresCliente,
												    		apellidosCliente, numeroCuenta, tipoCuenta,
												    		codigoMonedaCuenta, direccionCliente, tipoDireccion,
												    		correoCliente, telefonoCliente, tipoTelefono,
												    		numeroTarjeta, estadoCivil, genero,
												    		fechaNacimiento, indicadorCuenta);
  }
  
  public java.lang.String anulacionClienteTarjeta(String codigoCooperativa, String codigoUsuario, String ipTerminal, String numeroDocumento, String numeroTarjeta) throws RemoteException{
    if (wsRelacionClienteTarjeta == null)
      _initWsRelacionClienteTarjetaProxy();
    return wsRelacionClienteTarjeta.anulacionClienteTarjeta(codigoCooperativa, codigoUsuario, ipTerminal, numeroDocumento, numeroTarjeta);
  }
  
  
}