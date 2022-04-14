package tesoreria.bean;

import java.util.List;

import general.bean.BaseBean;

public class AsignarChequeSucurBean extends BaseBean{
	private String institucionID;
	private String nombreInstitucion;
	private String numCtaInstit;	
	private String folioUtilizar;
	private String sucursalID;
	private String nombreSucursal;
	private String estatus;
	private String cajaID;
	private String sucursalInstit;
	private String descripcionCaja;
	private String folioCheqInicial;
	private String folioCheqFinal;
	private String tipoChequera;
	
	//Variable para lista Combo de Cuenta de Cheques
	private String institucionCta;
	private String descripLista;
	private String existeFolio;
	private String cuentaClabe;
	private String rutaCheque;
	private String cuentaAhoID;
	
	private String listaCajas;
	private List valorListaCajas;	
	
	public String getInstitucionID() {
		return institucionID;
	}
	public void setInstitucionID(String institucionID) {
		this.institucionID = institucionID;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getNumCtaInstit() {
		return numCtaInstit;
	}
	public void setNumCtaInstit(String numCtaInstit) {
		this.numCtaInstit = numCtaInstit;
	}
	public String getFolioUtilizar() {
		return folioUtilizar;
	}
	public void setFolioUtilizar(String folioUtilizar) {
		this.folioUtilizar = folioUtilizar;
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
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public String getListaCajas() {
		return listaCajas;
	}
	public void setListaCajas(String listaCajas) {
		this.listaCajas = listaCajas;
	}
	public List getValorListaCajas() {
		return valorListaCajas;
	}
	public void setValorListaCajas(List valorListaCajas) {
		this.valorListaCajas = valorListaCajas;
	}
	public String getCajaID() {
		return cajaID;
	}
	public void setCajaID(String cajaID) {
		this.cajaID = cajaID;
	}
	public String getInstitucionCta() {
		return institucionCta;
	}
	public String getDescripLista() {
		return descripLista;
	}
	public void setInstitucionCta(String institucionCta) {
		this.institucionCta = institucionCta;
	}
	public void setDescripLista(String descripLista) {
		this.descripLista = descripLista;
	}
	public String getSucursalInstit() {
		return sucursalInstit;
	}
	public void setSucursalInstit(String sucursalInstit) {
		this.sucursalInstit = sucursalInstit;
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
	public String getExisteFolio() {
		return existeFolio;
	}
	public void setExisteFolio(String existeFolio) {
		this.existeFolio = existeFolio;
	}
	public String getCuentaClabe() {
		return cuentaClabe;
	}
	public void setCuentaClabe(String cuentaClabe) {
		this.cuentaClabe = cuentaClabe;
	}
	public String getRutaCheque() {
		return rutaCheque;
	}
	public void setRutaCheque(String rutaCheque) {
		this.rutaCheque = rutaCheque;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getTipoChequera() {
		return tipoChequera;
	}
	public void setTipoChequera(String tipoChequera) {
		this.tipoChequera = tipoChequera;
	}	
	
}
