package tesoreria.bean;

import general.bean.BaseBean;

public class RepAsignarChequesBean extends BaseBean {
	
	private String institucionID;
	private String nombreInstitucionBancaria;
	private String numCtaInstit;
	private String folioUsado;
	private String sucursalID;
	private String nombreSucursal;
	private String cajaID;
	private String descripcionCaja;
	private String folioCheqInicial;
	private String folioCheqFinal;
	private String foliosRestantes;
	private String tipoReporte;
	private String fechaInicioEmision;
	private String fechaFinalEmision;
	private String tipoChequera;

	public String getInstitucionID() {
		return institucionID;
	}

	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}

	public String getNombreInstitucionBancaria() {
		return nombreInstitucionBancaria;
	}

	public void setNombreInstitucionBancaria(String nombreInstitucionBancaria) {
		this.nombreInstitucionBancaria = nombreInstitucionBancaria;
	}

	public String getNumCtaInstit() {
		return numCtaInstit;
	}

	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}

	public String getFolioUsado() {
		return folioUsado;
	}

	public void setFolioUsado(String folioUsado) {
		this.folioUsado = folioUsado;
	}

	public String getSucursalID() {
		return sucursalID;
	}

	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}

	public String getNombreSucursal() {
		return nombreSucursal;
	}

	public void setNombreSucursal(String nombreSucursal) {
		this.nombreSucursal = nombreSucursal;
	}

	public String getCajaID() {
		return cajaID;
	}

	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}

	public String getDescripcionCaja() {
		return descripcionCaja;
	}

	public void setDescripcionCaja(String descripcionCaja) {
		this.descripcionCaja = descripcionCaja;
	}

	public String getFolioCheqInicial() {
		return folioCheqInicial;
	}

	public void setFolioCheqInicial(String folioCheqInicial) {
		this.folioCheqInicial = folioCheqInicial;
	}

	public String getFolioCheqFinal() {
		return folioCheqFinal;
	}

	public void setFolioCheqFinal(String folioCheqFinal) {
		this.folioCheqFinal = folioCheqFinal;
	}

	public String getFoliosRestantes() {
		return foliosRestantes;
	}

	public void setFoliosRestantes(String foliosRestantes) {
		this.foliosRestantes = foliosRestantes;
	}

	public String getTipoReporte() {
		return tipoReporte;
	}

	public void setTipoReporte(String tipoReporte) {
		this.tipoReporte = tipoReporte;
	}

	public String getFechaInicioEmision() {
		return fechaInicioEmision;
	}

	public void setFechaInicioEmision(String fechaInicioEmision) {
		this.fechaInicioEmision = fechaInicioEmision;
	}

	public String getFechaFinalEmision() {
		return fechaFinalEmision;
	}

	public void setFechaFinalEmision(String fechaFinalEmision) {
		this.fechaFinalEmision = fechaFinalEmision;
	}

	public String getTipoChequera() {
		return tipoChequera;
	}

	public void setTipoChequera(String tipoChequera) {
		this.tipoChequera = tipoChequera;
	}

}
