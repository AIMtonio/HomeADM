package aportaciones.bean;

import java.util.List;

import general.bean.BaseBean;

public class TasasAportacionesBean extends BaseBean{
	
	private int tipoAportacionID;
	private String montoInferior;
	private String montoSuperior;
	private int plazoInferior;
	private int plazoSuperior;
	private String tasaFija;
	private String tasaBase; 
	private String sobreTasa;
	private String pisoTasa;
	private String TechoTasa;
	private int plazo;
	private String monto;
	private String valorGat;
	private String valorGatReal;
	private String descalculoInteres;
	private String nombreTasaBase;	
	
	private String tasaAnualizada;
	private String calculoInteres;
	private String tasaAportacionID;
	private String calificacion;
	private String provCompetencia;
	private String relaciones;
	private String plazoID;
	private String bandera;
	private String tasaID;
	private String tipoProdID;
	private String tipoInstrumentoID;
	private String tipoPersona;
	private String montosConTasa;
	private String montoID;
	
	/*Beans Auxiliares*/
	private List lSucursalID;
	private List lPlazaID;
	private List lSubDireccionID;		
	private List lDirVentasID;
	private List lEstadoID;
	private List lEstatus;
	
	/*Beans Auxiliares*/
	private String sucursalID;
	private String plazaID;
	private String subDireccionID;		
	private String dirVentasID;
	private String estadoID;
	private String estatus;
	
	public int getTipoAportacionID() {
		return tipoAportacionID;
	}
	public void setTipoAportacionID(int tipoAportacionID) {
		this.tipoAportacionID = tipoAportacionID;
	}
	public String getMontoInferior() {
		return montoInferior;
	}
	public void setMontoInferior(String montoInferior) {
		this.montoInferior = montoInferior;
	}
	public String getMontoSuperior() {
		return montoSuperior;
	}
	public void setMontoSuperior(String montoSuperior) {
		this.montoSuperior = montoSuperior;
	}
	public int getPlazoInferior() {
		return plazoInferior;
	}
	public void setPlazoInferior(int plazoInferior) {
		this.plazoInferior = plazoInferior;
	}
	public int getPlazoSuperior() {
		return plazoSuperior;
	}
	public void setPlazoSuperior(int plazoSuperior) {
		this.plazoSuperior = plazoSuperior;
	}
	public String getTasaFija() {
		return tasaFija;
	}
	public void setTasaFija(String tasaFija) {
		this.tasaFija = tasaFija;
	}
	public String getTasaBase() {
		return tasaBase;
	}
	public void setTasaBase(String tasaBase) {
		this.tasaBase = tasaBase;
	}
	public String getSobreTasa() {
		return sobreTasa;
	}
	public void setSobreTasa(String sobreTasa) {
		this.sobreTasa = sobreTasa;
	}
	public String getPisoTasa() {
		return pisoTasa;
	}
	public void setPisoTasa(String pisoTasa) {
		this.pisoTasa = pisoTasa;
	}
	public String getTechoTasa() {
		return TechoTasa;
	}
	public void setTechoTasa(String techoTasa) {
		TechoTasa = techoTasa;
	}
	public int getPlazo() {
		return plazo;
	}
	public void setPlazo(int plazo) {
		this.plazo = plazo;
	}
	public String getMonto() {
		return monto;
	}
	public void setMonto(String monto) {
		this.monto = monto;
	}
	public String getValorGat() {
		return valorGat;
	}
	public void setValorGat(String valorGat) {
		this.valorGat = valorGat;
	}
	public String getValorGatReal() {
		return valorGatReal;
	}
	public void setValorGatReal(String valorGatReal) {
		this.valorGatReal = valorGatReal;
	}
	public String getDescalculoInteres() {
		return descalculoInteres;
	}
	public void setDescalculoInteres(String descalculoInteres) {
		this.descalculoInteres = descalculoInteres;
	}
	public String getNombreTasaBase() {
		return nombreTasaBase;
	}
	public void setNombreTasaBase(String nombreTasaBase) {
		this.nombreTasaBase = nombreTasaBase;
	}
	public String getTasaAnualizada() {
		return tasaAnualizada;
	}
	public void setTasaAnualizada(String tasaAnualizada) {
		this.tasaAnualizada = tasaAnualizada;
	}
	public String getCalculoInteres() {
		return calculoInteres;
	}
	public void setCalculoInteres(String calculoInteres) {
		this.calculoInteres = calculoInteres;
	}
	public String getTasaAportacionID() {
		return tasaAportacionID;
	}
	public void setTasaAportacionID(String tasaAportacionID) {
		this.tasaAportacionID = tasaAportacionID;
	}
	public String getCalificacion() {
		return calificacion;
	}
	public void setCalificacion(String calificacion) {
		this.calificacion = calificacion;
	}
	public String getProvCompetencia() {
		return provCompetencia;
	}
	public void setProvCompetencia(String provCompetencia) {
		this.provCompetencia = provCompetencia;
	}
	public String getRelaciones() {
		return relaciones;
	}
	public void setRelaciones(String relaciones) {
		this.relaciones = relaciones;
	}
	public String getPlazoID() {
		return plazoID;
	}
	public void setPlazoID(String plazoID) {
		this.plazoID = plazoID;
	}
	public String getBandera() {
		return bandera;
	}
	public void setBandera(String bandera) {
		this.bandera = bandera;
	}
	public String getTasaID() {
		return tasaID;
	}
	public void setTasaID(String tasaID) {
		this.tasaID = tasaID;
	}
	public String getTipoProdID() {
		return tipoProdID;
	}
	public void setTipoProdID(String tipoProdID) {
		this.tipoProdID = tipoProdID;
	}
	public String getTipoInstrumentoID() {
		return tipoInstrumentoID;
	}
	public void setTipoInstrumentoID(String tipoInstrumentoID) {
		this.tipoInstrumentoID = tipoInstrumentoID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getMontosConTasa() {
		return montosConTasa;
	}
	public void setMontosConTasa(String montosConTasa) {
		this.montosConTasa = montosConTasa;
	}
	public List getlSucursalID() {
		return lSucursalID;
	}
	public void setlSucursalID(List lSucursalID) {
		this.lSucursalID = lSucursalID;
	}
	public List getlPlazaID() {
		return lPlazaID;
	}
	public void setlPlazaID(List lPlazaID) {
		this.lPlazaID = lPlazaID;
	}
	public List getlSubDireccionID() {
		return lSubDireccionID;
	}
	public void setlSubDireccionID(List lSubDireccionID) {
		this.lSubDireccionID = lSubDireccionID;
	}
	public List getlDirVentasID() {
		return lDirVentasID;
	}
	public void setlDirVentasID(List lDirVentasID) {
		this.lDirVentasID = lDirVentasID;
	}
	public List getlEstadoID() {
		return lEstadoID;
	}
	public void setlEstadoID(List lEstadoID) {
		this.lEstadoID = lEstadoID;
	}
	public List getlEstatus() {
		return lEstatus;
	}
	public void setlEstatus(List lEstatus) {
		this.lEstatus = lEstatus;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getPlazaID() {
		return plazaID;
	}
	public void setPlazaID(String plazaID) {
		this.plazaID = plazaID;
	}
	public String getSubDireccionID() {
		return subDireccionID;
	}
	public void setSubDireccionID(String subDireccionID) {
		this.subDireccionID = subDireccionID;
	}
	public String getDirVentasID() {
		return dirVentasID;
	}
	public void setDirVentasID(String dirVentasID) {
		this.dirVentasID = dirVentasID;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getMontoID() {
		return montoID;
	}
	public void setMontoID(String montoID) {
		this.montoID = montoID;
	}
	
	

}
