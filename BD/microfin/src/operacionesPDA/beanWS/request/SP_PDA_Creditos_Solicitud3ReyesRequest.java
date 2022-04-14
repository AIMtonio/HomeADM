package operacionesPDA.beanWS.request;

import java.util.ArrayList;
import java.util.List;

import general.bean.BaseBeanWS;

public class SP_PDA_Creditos_Solicitud3ReyesRequest extends BaseBeanWS{
	private String Num_Socio;
	private String Monto;
	private String Fecha_Mov;
	private String Promotor;
	private String Sucursal;
	private String DestinoCred;
	private String Dispercion;
	private String TipoPago;
	private String NumCuota;
	private String TasaFija;
	private String Plazo;
	private String FecuenciaCap;
	private String FecuenciaInt;
	private String Folio_Pda;
	private String Id_Usuario;
	private String Clave;
	private String Dispositivo;

	private List<ArrayList> Parametros;	
	private List<ArrayList> ParametroComponente;

	
	public String getNum_Socio() {
		return Num_Socio;
	}
	public void setNum_Socio(String num_Socio) {
		Num_Socio = num_Socio;
	}
	public String getMonto() {
		return Monto;
	}
	public void setMonto(String monto) {
		Monto = monto;
	}
	public String getFecha_Mov() {
		return Fecha_Mov;
	}
	public void setFecha_Mov(String fecha_Mov) {
		Fecha_Mov = fecha_Mov;
	}	
	public String getPromotor() {
		return Promotor;
	}
	public void setPromotor(String promotor) {
		Promotor = promotor;
	}
	public String getSucursal() {
		return Sucursal;
	}
	public void setSucursal(String sucursal) {
		Sucursal = sucursal;
	}
	public String getDestinoCred() {
		return DestinoCred;
	}
	public void setDestinoCred(String destinoCred) {
		DestinoCred = destinoCred;
	}
	public String getDispercion() {
		return Dispercion;
	}
	public void setDispercion(String dispercion) {
		Dispercion = dispercion;
	}
	public String getTipoPago() {
		return TipoPago;
	}
	public void setTipoPago(String tipoPago) {
		TipoPago = tipoPago;
	}
	public String getNumCuota() {
		return NumCuota;
	}
	public void setNumCuota(String numCuota) {
		NumCuota = numCuota;
	}
	public String getTasaFija() {
		return TasaFija;
	}
	public void setTasaFija(String tasaFija) {
		TasaFija = tasaFija;
	}
	public String getPlazo() {
		return Plazo;
	}
	public void setPlazo(String plazo) {
		Plazo = plazo;
	}
	public String getFecuenciaCap() {
		return FecuenciaCap;
	}
	public void setFecuenciaCap(String fecuenciaCap) {
		FecuenciaCap = fecuenciaCap;
	}
	public String getFecuenciaInt() {
		return FecuenciaInt;
	}
	public void setFecuenciaInt(String fecuenciaInt) {
		FecuenciaInt = fecuenciaInt;
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

}
