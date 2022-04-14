package operacionesPDM.beanWS.request;

import general.bean.BaseBeanWS;

public class SP_PDM_Ahorros_RetiroCtaRequest extends BaseBeanWS {

	private String num_Socio;
	private String num_Cta;
	private String monto;
	private String fecha_Mov;
	private String folio_Pda;
	private String id_Usuario;
	private String clave;
	private String dispositivo;
	private String idServicio;
	private String tipoOperacion;
	private String referencia;
	
	public String getNum_Socio() {
		return num_Socio;
	}
	public void setNum_Socio(String num_Socio) {
		this.num_Socio = num_Socio;
	}
	public String getNum_Cta() {
		return num_Cta;
	}
	public void setNum_Cta(String num_Cta) {
		this.num_Cta = num_Cta;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getFecha_Mov() {
		return fecha_Mov;
	}
	public void setFecha_Mov(String fecha_Mov) {
		this.fecha_Mov = fecha_Mov;
	}
	public String getFolio_Pda() {
		return folio_Pda;
	}
	public void setFolio_Pda(String folio_Pda) {
		this.folio_Pda = folio_Pda;
	}
	public String getId_Usuario() {
		return id_Usuario;
	}
	public void setId_Usuario(String id_Usuario) {
		this.id_Usuario = id_Usuario;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public String getDispositivo() {
		return dispositivo;
	}
	public void setDispositivo(String dispositivo) {
		this.dispositivo = dispositivo;
	}
	public String getIdServicio() {
		return idServicio;
	}
	public void setIdServicio(String idServicio) {
		this.idServicio = idServicio;
	}
	public String getTipoOperacion() {
		return tipoOperacion;
	}
	public void setTipoOperacion(String tipoOperacion) {
		this.tipoOperacion = tipoOperacion;
	}
	public String getReferencia() {
		return referencia;
	}
	public void setReferencia(String referencia) {
		this.referencia = referencia;
	}	
	
}
