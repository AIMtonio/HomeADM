package operacionesPDA.beanWS.request;

import java.util.ArrayList;
import java.util.List;

import general.bean.BaseBeanWS;

public class SP_PDA_Socio_Alta3ReyesRequest extends BaseBeanWS{
	
private String Nombre;
private String ApPaterno;
private String ApMaterno;
private String FecNacimiento;
private String Rfc;
private String Curp;
private String Monto;
private String Sucursal;
private String Mail;
private String PaisDeNacimiento;
private String EntiFedNacimiento;
private String Nacionalidad;
private String PaisDeResidencia;
private String Sexo;
private String TelefonoParticular;
private String SectorGeneral;
private String ActividadBMX;
private String ActividadFR;
private String PromotorInicial;
private String PromotorActual;
private String EsMenor;
private String Numero;
private String TipoDeDireccion;
private String EntidadFederativa;
private String Municipio;
private String Localidad;
private String Colonia;
private String Calle;
private String NumeroDireccion;
private String CodigoPostal;
private String Oficial;
private String Folio;
private String Tipo;
private String EsOficial;
private String FechaExpedicion;
private String FechaVencimiento;
private String Folio_Pda;
private String Id_Usuario;
private String Clave;
private String Dispositivo;

private String nombre1;
private String nombre2;
private String nombre3;



private List<ArrayList> Parametros;	
private List<ArrayList> ParametroComponente;


public String getNombre() {
	return Nombre;
}
public void setNombre(String nombre) {
	Nombre = nombre;
}
public String getApPaterno() {
	return ApPaterno;
}
public void setApPaterno(String apPaterno) {
	ApPaterno = apPaterno;
}
public String getApMaterno() {
	return ApMaterno;
}
public void setApMaterno(String apMaterno) {
	ApMaterno = apMaterno;
}
public String getFecNacimiento() {
	return FecNacimiento;
}
public void setFecNacimiento(String fecNacimiento) {
	FecNacimiento = fecNacimiento;
}
public String getRfc() {
	return Rfc;
}
public void setRfc(String rfc) {
	Rfc = rfc;
}
public String getCurp() {
	return Curp;
}
public void setCurp(String curp) {
	Curp = curp;
}
public String getMonto() {
	return Monto;
}
public void setMonto(String monto) {
	Monto = monto;
}
public String getSucursal() {
	return Sucursal;
}
public void setSucursal(String sucursal) {
	Sucursal = sucursal;
}
public String getMail() {
	return Mail;
}
public void setMail(String mail) {
	Mail = mail;
}
public String getPaisDeNacimiento() {
	return PaisDeNacimiento;
}
public void setPaisDeNacimiento(String paisDeNacimiento) {
	PaisDeNacimiento = paisDeNacimiento;
}
public String getEntiFedNacimiento() {
	return EntiFedNacimiento;
}
public void setEntiFedNacimiento(String entiFedNacimiento) {
	EntiFedNacimiento = entiFedNacimiento;
}
public String getNacionalidad() {
	return Nacionalidad;
}
public void setNacionalidad(String nacionalidad) {
	Nacionalidad = nacionalidad;
}
public String getPaisDeResidencia() {
	return PaisDeResidencia;
}
public void setPaisDeResidencia(String paisDeResidencia) {
	PaisDeResidencia = paisDeResidencia;
}
public String getSexo() {
	return Sexo;
}
public void setSexo(String sexo) {
	Sexo = sexo;
}
public String getTelefonoParticular() {
	return TelefonoParticular;
}
public void setTelefonoParticular(String telefonoParticular) {
	TelefonoParticular = telefonoParticular;
}
public String getSectorGeneral() {
	return SectorGeneral;
}
public void setSectorGeneral(String sectorGeneral) {
	SectorGeneral = sectorGeneral;
}
public String getActividadBMX() {
	return ActividadBMX;
}
public void setActividadBMX(String actividadBMX) {
	ActividadBMX = actividadBMX;
}
public String getActividadFR() {
	return ActividadFR;
}
public void setActividadFR(String actividadFR) {
	ActividadFR = actividadFR;
}
public String getPromotorInicial() {
	return PromotorInicial;
}
public void setPromotorInicial(String promotorInicial) {
	PromotorInicial = promotorInicial;
}
public String getPromotorActual() {
	return PromotorActual;
}
public void setPromotorActual(String promotorActual) {
	PromotorActual = promotorActual;
}
public String getEsMenor() {
	return EsMenor;
}
public void setEsMenor(String esMenor) {
	EsMenor = esMenor;
}
public String getNumero() {
	return Numero;
}
public void setNumero(String numero) {
	Numero = numero;
}
public String getTipoDeDireccion() {
	return TipoDeDireccion;
}
public void setTipoDeDireccion(String tipoDeDireccion) {
	TipoDeDireccion = tipoDeDireccion;
}
public String getEntidadFederativa() {
	return EntidadFederativa;
}
public void setEntidadFederativa(String entidadFederativa) {
	EntidadFederativa = entidadFederativa;
}
public String getMunicipio() {
	return Municipio;
}
public void setMunicipio(String municipio) {
	Municipio = municipio;
}
public String getLocalidad() {
	return Localidad;
}
public void setLocalidad(String localidad) {
	Localidad = localidad;
}
public String getColonia() {
	return Colonia;
}
public void setColonia(String colonia) {
	Colonia = colonia;
}
public String getCalle() {
	return Calle;
}
public void setCalle(String calle) {
	Calle = calle;
}
public String getNumeroDireccion() {
	return NumeroDireccion;
}
public void setNumeroDireccion(String numeroDireccion) {
	NumeroDireccion = numeroDireccion;
}
public String getCodigoPostal() {
	return CodigoPostal;
}
public void setCodigoPostal(String codigoPostal) {
	CodigoPostal = codigoPostal;
}
public String getOficial() {
	return Oficial;
}
public void setOficial(String oficial) {
	Oficial = oficial;
}
public String getFolio() {
	return Folio;
}
public void setFolio(String folio) {
	Folio = folio;
}
public String getTipo() {
	return Tipo;
}
public void setTipo(String tipo) {
	Tipo = tipo;
}
public String getEsOficial() {
	return EsOficial;
}
public void setEsOficial(String esOficial) {
	EsOficial = esOficial;
}
public String getFechaExpedicion() {
	return FechaExpedicion;
}
public void setFechaExpedicion(String fechaExpedicion) {
	FechaExpedicion = fechaExpedicion;
}
public String getFechaVencimiento() {
	return FechaVencimiento;
}
public void setFechaVencimiento(String fechaVencimiento) {
	FechaVencimiento = fechaVencimiento;
}
public String getFolio_Pda() {
	return Folio_Pda;
}
public void setFolio_Pda(String folio_Pda) {
	Folio_Pda = folio_Pda;
}
public String getId_Usuario() {
	return Id_Usuario;
}
public void setId_Usuario(String id_Usuario) {
	Id_Usuario = id_Usuario;
}
public String getClave() {
	return Clave;
}
public void setClave(String clave) {
	Clave = clave;
}
public String getDispositivo() {
	return Dispositivo;
}
public void setDispositivo(String dispositivo) {
	Dispositivo = dispositivo;
}




public List<ArrayList> getParametros() {
	return Parametros;
}
public void setParametros(List<ArrayList> parametros) {
	Parametros = parametros;
}
public List<ArrayList> getParametroComponente() {
	return ParametroComponente;
}
public void setParametroComponente(List<ArrayList> parametroComponente) {
	ParametroComponente = parametroComponente;
}





public String getNombre1() {
	return nombre1;
}
public void setNombre1(String nombre1) {
	this.nombre1 = nombre1;
}
public String getNombre2() {
	return nombre2;
}
public void setNombre2(String nombre2) {
	this.nombre2 = nombre2;
}
public String getNombre3() {
	return nombre3;
}
public void setNombre3(String nombre3) {
	this.nombre3 = nombre3;
}

}
