package operacionesPDA.beanWS.request;

import java.util.ArrayList;
import java.util.List;

import operacionesPDA.bean.DatosIntegrantesBean;
import general.bean.BaseBeanWS;

public class AltaSolicitudGrupalRequest extends BaseBeanWS {

	private String prospectoID;
	private String clienteID;
	private String destinoCredito;
	private String proyecto;
	private String montoSolici;
	private String tipoIntegrante;
	private String grupoID;
	private String productoCreditoID;
	private String periodicidad;
	private String plazo;
	private String tipoDispersion;
	private String cuentaCLABE;
	private String tipoPagoCapital;
	private String folio;
	private String claveUsuario;
	private String dispositivo;

	private List<ArrayList> integrantes;
	private DatosIntegrantesBean datosIntegrante;

	public String getProspectoID() {
		return prospectoID;
	}

	public void setProspectoID(String prospectoID) {
		this.prospectoID = prospectoID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getProductoCreditoID() {
		return productoCreditoID;
	}

	public void setProductoCreditoID(String productoCreditoID) {
		this.productoCreditoID = productoCreditoID;
	}

	public String getMontoSolici() {
		return montoSolici;
	}

	public void setMontoSolici(String montoSolici) {
		this.montoSolici = montoSolici;
	}

	public String getPeriodicidad() {
		return periodicidad;
	}

	public void setPeriodicidad(String periodicidad) {
		this.periodicidad = periodicidad;
	}

	public String getPlazo() {
		return plazo;
	}

	public void setPlazo(String plazo) {
		this.plazo = plazo;
	}

	public String getDestinoCredito() {
		return destinoCredito;
	}

	public void setDestinoCredito(String destinoCredito) {
		this.destinoCredito = destinoCredito;
	}

	public String getProyecto() {
		return proyecto;
	}

	public void setProyecto(String proyecto) {
		this.proyecto = proyecto;
	}

	public String getTipoDispersion() {
		return tipoDispersion;
	}

	public void setTipoDispersion(String tipoDispersion) {
		this.tipoDispersion = tipoDispersion;
	}

	public String getCuentaCLABE() {
		return cuentaCLABE;
	}

	public void setCuentaCLABE(String cuentaCLABE) {
		this.cuentaCLABE = cuentaCLABE;
	}

	public String getTipoPagoCapital() {
		return tipoPagoCapital;
	}

	public void setTipoPagoCapital(String tipoPagoCapital) {
		this.tipoPagoCapital = tipoPagoCapital;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getClaveUsuario() {
		return claveUsuario;
	}

	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}

	public String getDispositivo() {
		return dispositivo;
	}

	public void setDispositivo(String dispositivo) {
		this.dispositivo = dispositivo;
	}

	public String getGrupoID() {
		return grupoID;
	}

	public void setGrupoID(String grupoID) {
		this.grupoID = grupoID;
	}

	public String getTipoIntegrante() {
		return tipoIntegrante;
	}

	public void setTipoIntegrante(String tipoIntegrante) {
		this.tipoIntegrante = tipoIntegrante;
	}

	public List<ArrayList> getIntegrantes() {
		return integrantes;
	}

	public void setIntegrantes(List<ArrayList> integrantes) {
		this.integrantes = integrantes;
	}

	public DatosIntegrantesBean getDatosIntegrante() {
		return datosIntegrante;
	}

	public void setDatosIntegrante(DatosIntegrantesBean datosIntegrante) {
		this.datosIntegrante = datosIntegrante;
	}

}
