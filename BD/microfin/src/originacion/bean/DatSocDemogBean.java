package originacion.bean;
// datos sociodemograficos
import java.util.List;

import general.bean.BaseBean;
public class DatSocDemogBean extends BaseBean {

	// SOCIODEMOGRAL
	private String prospectoID	;
	private String clienteID;
	private String ProspID	;
	private String cliID;
	private String fechaRegistro;
	private String gradoEscolarID; 
	private String numDepenEconomi;
	
	private String tipoRel;
	private String primerNombre;
	private String segundNombre;
	private String tercerNombre; 
	private String apellidoPaterno;	
	private String apellidoMaterno;
	private String edad;
	private String ocupacion;
	private String fechaIniTra;
	
	//SOCIODEMODEPEND	 
	private List tipoRelacion;
	private List primerNomb	;
	private List segundNomb;
	private List tercerNomb	; 
	private List apePaterno;	
	private List apeMaterno;
	private List edades;
	private List ocupaciones;
	
	//TIPORELACIONES
	private String descripRelacion;
	
	//OCUPACIONES
	private String descripOcupacion;
	
	//CATGRADOESCOLAR
	private String descriGdoEscolar;
	
	private String antiguedadLab;
	
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
	public String getProspID() {
		return ProspID;
	}
	public void setProspID(String prospID) {
		ProspID = prospID;
	}
	public String getCliID() {
		return cliID;
	}
	public void setCliID(String cliID) {
		this.cliID = cliID;
	}
	public String getDescripRelacion() {
		return descripRelacion;
	}
	public void setDescripRelacion(String descripRelacion) {
		this.descripRelacion = descripRelacion;
	}
	public String getDescripOcupacion() {
		return descripOcupacion;
	}
	public void setDescripOcupacion(String descripOcupacion) {
		this.descripOcupacion = descripOcupacion;
	}
	public String getDescriGdoEscolar() {
		return descriGdoEscolar;
	}
	public void setDescriGdoEscolar(String descriGdoEscolar) {
		this.descriGdoEscolar = descriGdoEscolar;
	}
	
	public String getFechaRegistro() {
		return fechaRegistro;
	}
	public void setFechaRegistro(String fechaRegistro) {
		this.fechaRegistro = fechaRegistro;
	}
	public String getGradoEscolarID() {
		return gradoEscolarID;
	}
	public void setGradoEscolarID(String gradoEscolarID) {
		this.gradoEscolarID = gradoEscolarID;
	}
	public String getNumDepenEconomi() {
		return numDepenEconomi;
	}
	public void setNumDepenEconomi(String numDepenEconomi) {
		this.numDepenEconomi = numDepenEconomi;
	}
	public String getTipoRel() {
		return tipoRel;
	}
	public void setTipoRel(String tipoRel) {
		this.tipoRel = tipoRel;
	}
	public String getPrimerNombre() {
		return primerNombre;
	}
	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}
	public String getSegundNombre() {
		return segundNombre;
	}
	public void setSegundNombre(String segundNombre) {
		this.segundNombre = segundNombre;
	}
	public String getTercerNombre() {
		return tercerNombre;
	}
	public void setTercerNombre(String tercerNombre) {
		this.tercerNombre = tercerNombre;
	}
	public String getApellidoPaterno() {
		return apellidoPaterno;
	}
	public void setApellidoPaterno(String apellidoPaterno) {
		this.apellidoPaterno = apellidoPaterno;
	}
	public String getApellidoMaterno() {
		return apellidoMaterno;
	}
	public void setApellidoMaterno(String apellidoMaterno) {
		this.apellidoMaterno = apellidoMaterno;
	}
	public String getEdad() {
		return edad;
	}
	public void setEdad(String edad) {
		this.edad = edad;
	}
	public String getOcupacion() {
		return ocupacion;
	}
	public void setOcupacion(String ocupacion) {
		this.ocupacion = ocupacion;
	}
	public List getTipoRelacion() {
		return tipoRelacion;
	}
	public void setTipoRelacion(List tipoRelacion) {
		this.tipoRelacion = tipoRelacion;
	}
	public List getPrimerNomb() {
		return primerNomb;
	}
	public void setPrimerNomb(List primerNomb) {
		this.primerNomb = primerNomb;
	}
	public List getSegundNomb() {
		return segundNomb;
	}
	public void setSegundNomb(List segundNomb) {
		this.segundNomb = segundNomb;
	}
	public List getTercerNomb() {
		return tercerNomb;
	}
	public void setTercerNomb(List tercerNomb) {
		this.tercerNomb = tercerNomb;
	}
	public List getApePaterno() {
		return apePaterno;
	}
	public void setApePaterno(List apePaterno) {
		this.apePaterno = apePaterno;
	}
	public List getApeMaterno() {
		return apeMaterno;
	}
	public void setApeMaterno(List apeMaterno) {
		this.apeMaterno = apeMaterno;
	}
	public List getEdades() {
		return edades;
	}
	public void setEdades(List edades) {
		this.edades = edades;
	}
	public List getOcupaciones() {
		return ocupaciones;
	}
	public void setOcupaciones(List ocupaciones) {
		this.ocupaciones = ocupaciones;
	}
	public String getAntiguedadLab() {
		return antiguedadLab;
	}
	public void setAntiguedadLab(String antiguedadLab) {
		this.antiguedadLab = antiguedadLab;
	}
	public String getFechaIniTra() {
		return fechaIniTra;
	}
	public void setFechaIniTra(String fechaIniTra) {
		this.fechaIniTra = fechaIniTra;
	}
	
	
	
}

