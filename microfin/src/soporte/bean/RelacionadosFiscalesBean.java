package soporte.bean;

import general.bean.BaseBean;

import java.util.ArrayList;
import java.util.List;

public class RelacionadosFiscalesBean extends BaseBean{
	private String clienteID;
	private String participaFiscalCte;
	private String ejercicio;
	private String tipoRelacionado;
	private String cteRelacionadoID;
	
	private String participacionFiscal;
	private String tipoPersona;
	private String primerNombre;
	private String segundoNombre;
	private String tercerNombre;
	
	private String apellidoPaterno;
	private String apellidoMaterno;
	private String registroHacienda;
	private String nacion;
	private String paisResidencia;
	
	private String RFC;
	private String CURP;
	private String estadoID;
	private String municipioID;
	private String localidadID;
	
	private String coloniaID;
	private String calle;
	private String numeroCasa;
	private String numInterior;
	private String piso;
	
	private String CP;
	private String lote;
	private String manzana;
	private String direccionCompleta;
	private String nombreCompletoCte;
	

	private List lisTipoRelacionado;
	private List lisCteRelacionadoID;
	
	private List lisParticipacionFiscal;
	private List lisTipoPersona;
	private List lisPrimerNombre;
	private List lisSegundoNombre;
	private List lisTercerNombre;
	
	private List lisApellidoPaterno;
	private List lisApellidoMaterno;
	private List lisRegistroHacienda;
	private List lisNacion;
	private List lisPaisResidencia;
	
	private List lisRFC;
	private List lisCURP;
	private List lisEstadoID;
	private List lisMunicipioID;
	private List lisLocalidadID;
	
	private List lisColoniaID;
	private List lisCalle;
	private List lisNumeroCasa;
	private List lisNumInterior;
	private List lisPiso;
	
	private List lisCP;
	private List lisLote;
	private List lisManzana;
	private List lisDireccionCompleta;
	
	//CAMPOS REPORTE
	private String tipo;	
	private String capital;
	private String interesRealPeriodo;	
	private String interesNominalPeriodo;	
	private String ISRRetenido;	
	
	private String perdidaReal;
	private String nombreInstitucion;
	private String claveUsuario;
	private String fechaSistema;

	
	public String getClienteID() {
		return clienteID;
	}
	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}
	public String getParticipaFiscalCte() {
		return participaFiscalCte;
	}
	public void setParticipaFiscalCte(String participaFiscalCte) {
		this.participaFiscalCte = participaFiscalCte;
	}
	public String getEjercicio() {
		return ejercicio;
	}
	public void setEjercicio(String ejercicio) {
		this.ejercicio = ejercicio;
	}
	public String getTipoRelacionado() {
		return tipoRelacionado;
	}
	public void setTipoRelacionado(String tipoRelacionado) {
		this.tipoRelacionado = tipoRelacionado;
	}
	public String getCteRelacionadoID() {
		return cteRelacionadoID;
	}
	public void setCteRelacionadoID(String cteRelacionadoID) {
		this.cteRelacionadoID = cteRelacionadoID;
	}
	public String getParticipacionFiscal() {
		return participacionFiscal;
	}
	public void setParticipacionFiscal(String participacionFiscal) {
		this.participacionFiscal = participacionFiscal;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getPrimerNombre() {
		return primerNombre;
	}
	public void setPrimerNombre(String primerNombre) {
		this.primerNombre = primerNombre;
	}
	public String getSegundoNombre() {
		return segundoNombre;
	}
	public void setSegundoNombre(String segundoNombre) {
		this.segundoNombre = segundoNombre;
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
	public String getRegistroHacienda() {
		return registroHacienda;
	}
	public void setRegistroHacienda(String registroHacienda) {
		this.registroHacienda = registroHacienda;
	}
	public String getNacion() {
		return nacion;
	}
	public void setNacion(String nacion) {
		this.nacion = nacion;
	}
	public String getPaisResidencia() {
		return paisResidencia;
	}
	public void setPaisResidencia(String paisResidencia) {
		this.paisResidencia = paisResidencia;
	}
	public String getEstadoID() {
		return estadoID;
	}
	public void setEstadoID(String estadoID) {
		this.estadoID = estadoID;
	}
	public String getMunicipioID() {
		return municipioID;
	}
	public void setMunicipioID(String municipioID) {
		this.municipioID = municipioID;
	}
	public String getLocalidadID() {
		return localidadID;
	}
	public void setLocalidadID(String localidadID) {
		this.localidadID = localidadID;
	}
	public String getColoniaID() {
		return coloniaID;
	}
	public void setColoniaID(String coloniaID) {
		this.coloniaID = coloniaID;
	}
	public String getCalle() {
		return calle;
	}
	public void setCalle(String calle) {
		this.calle = calle;
	}
	public String getNumeroCasa() {
		return numeroCasa;
	}
	public void setNumeroCasa(String numeroCasa) {
		this.numeroCasa = numeroCasa;
	}
	public String getNumInterior() {
		return numInterior;
	}
	public void setNumInterior(String numInterior) {
		this.numInterior = numInterior;
	}
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
	}
	public String getLote() {
		return lote;
	}
	public void setLote(String lote) {
		this.lote = lote;
	}
	public String getManzana() {
		return manzana;
	}
	public void setManzana(String manzana) {
		this.manzana = manzana;
	}
	public String getDireccionCompleta() {
		return direccionCompleta;
	}
	public void setDireccionCompleta(String direccionCompleta) {
		this.direccionCompleta = direccionCompleta;
	}
	public String getNombreCompletoCte() {
		return nombreCompletoCte;
	}
	public void setNombreCompletoCte(String nombreCompletoCte) {
		this.nombreCompletoCte = nombreCompletoCte;
	}
	public List getLisTipoRelacionado() {
		return lisTipoRelacionado;
	}
	public void setLisTipoRelacionado(List lisTipoRelacionado) {
		this.lisTipoRelacionado = lisTipoRelacionado;
	}
	public List getLisCteRelacionadoID() {
		return lisCteRelacionadoID;
	}
	public void setLisCteRelacionadoID(List lisCteRelacionadoID) {
		this.lisCteRelacionadoID = lisCteRelacionadoID;
	}
	public List getLisParticipacionFiscal() {
		return lisParticipacionFiscal;
	}
	public void setLisParticipacionFiscal(List lisParticipacionFiscal) {
		this.lisParticipacionFiscal = lisParticipacionFiscal;
	}
	public List getLisTipoPersona() {
		return lisTipoPersona;
	}
	public void setLisTipoPersona(List lisTipoPersona) {
		this.lisTipoPersona = lisTipoPersona;
	}
	public List getLisPrimerNombre() {
		return lisPrimerNombre;
	}
	public void setLisPrimerNombre(List lisPrimerNombre) {
		this.lisPrimerNombre = lisPrimerNombre;
	}
	public List getLisSegundoNombre() {
		return lisSegundoNombre;
	}
	public void setLisSegundoNombre(List lisSegundoNombre) {
		this.lisSegundoNombre = lisSegundoNombre;
	}
	public List getLisTercerNombre() {
		return lisTercerNombre;
	}
	public void setLisTercerNombre(List lisTercerNombre) {
		this.lisTercerNombre = lisTercerNombre;
	}
	public List getLisApellidoPaterno() {
		return lisApellidoPaterno;
	}
	public void setLisApellidoPaterno(List lisApellidoPaterno) {
		this.lisApellidoPaterno = lisApellidoPaterno;
	}
	public List getLisApellidoMaterno() {
		return lisApellidoMaterno;
	}
	public void setLisApellidoMaterno(List lisApellidoMaterno) {
		this.lisApellidoMaterno = lisApellidoMaterno;
	}
	public List getLisRegistroHacienda() {
		return lisRegistroHacienda;
	}
	public void setLisRegistroHacienda(List lisRegistroHacienda) {
		this.lisRegistroHacienda = lisRegistroHacienda;
	}
	public List getLisNacion() {
		return lisNacion;
	}
	public void setLisNacion(List lisNacion) {
		this.lisNacion = lisNacion;
	}
	public List getLisPaisResidencia() {
		return lisPaisResidencia;
	}
	public void setLisPaisResidencia(List lisPaisResidencia) {
		this.lisPaisResidencia = lisPaisResidencia;
	}
	public List getLisRFC() {
		return lisRFC;
	}
	public void setLisRFC(List lisRFC) {
		this.lisRFC = lisRFC;
	}
	public List getLisCURP() {
		return lisCURP;
	}
	public void setLisCURP(List lisCURP) {
		this.lisCURP = lisCURP;
	}
	public List getLisEstadoID() {
		return lisEstadoID;
	}
	public void setLisEstadoID(List lisEstadoID) {
		this.lisEstadoID = lisEstadoID;
	}
	public List getLisMunicipioID() {
		return lisMunicipioID;
	}
	public void setLisMunicipioID(List lisMunicipioID) {
		this.lisMunicipioID = lisMunicipioID;
	}
	public List getLisLocalidadID() {
		return lisLocalidadID;
	}
	public void setLisLocalidadID(List lisLocalidadID) {
		this.lisLocalidadID = lisLocalidadID;
	}
	public List getLisColoniaID() {
		return lisColoniaID;
	}
	public void setLisColoniaID(List lisColoniaID) {
		this.lisColoniaID = lisColoniaID;
	}
	public List getLisCalle() {
		return lisCalle;
	}
	public void setLisCalle(List lisCalle) {
		this.lisCalle = lisCalle;
	}
	public List getLisNumeroCasa() {
		return lisNumeroCasa;
	}
	public void setLisNumeroCasa(List lisNumeroCasa) {
		this.lisNumeroCasa = lisNumeroCasa;
	}
	public List getLisNumInterior() {
		return lisNumInterior;
	}
	public void setLisNumInterior(List lisNumInterior) {
		this.lisNumInterior = lisNumInterior;
	}
	public List getLisPiso() {
		return lisPiso;
	}
	public void setLisPiso(List lisPiso) {
		this.lisPiso = lisPiso;
	}
	public List getLisCP() {
		return lisCP;
	}
	public void setLisCP(List lisCP) {
		this.lisCP = lisCP;
	}
	public List getLisLote() {
		return lisLote;
	}
	public void setLisLote(List lisLote) {
		this.lisLote = lisLote;
	}
	public List getLisManzana() {
		return lisManzana;
	}
	public void setLisManzana(List lisManzana) {
		this.lisManzana = lisManzana;
	}
	public List getLisDireccionCompleta() {
		return lisDireccionCompleta;
	}
	public void setLisDireccionCompleta(List lisDireccionCompleta) {
		this.lisDireccionCompleta = lisDireccionCompleta;
	}
	public String getRFC() {
		return RFC;
	}
	public void setRFC(String rFC) {
		RFC = rFC;
	}
	public String getCURP() {
		return CURP;
	}
	public void setCURP(String cURP) {
		CURP = cURP;
	}
	public String getCP() {
		return CP;
	}
	public void setCP(String cP) {
		CP = cP;
	}
	public String getTipo() {
		return tipo;
	}
	public void setTipo(String tipo) {
		this.tipo = tipo;
	}
	public String getCapital() {
		return capital;
	}
	public void setCapital(String capital) {
		this.capital = capital;
	}
	public String getInteresRealPeriodo() {
		return interesRealPeriodo;
	}
	public void setInteresRealPeriodo(String interesRealPeriodo) {
		this.interesRealPeriodo = interesRealPeriodo;
	}
	public String getInteresNominalPeriodo() {
		return interesNominalPeriodo;
	}
	public void setInteresNominalPeriodo(String interesNominalPeriodo) {
		this.interesNominalPeriodo = interesNominalPeriodo;
	}
	public String getISRRetenido() {
		return ISRRetenido;
	}
	public void setISRRetenido(String iSRRetenido) {
		ISRRetenido = iSRRetenido;
	}
	public String getPerdidaReal() {
		return perdidaReal;
	}
	public void setPerdidaReal(String perdidaReal) {
		this.perdidaReal = perdidaReal;
	}
	public String getNombreInstitucion() {
		return nombreInstitucion;
	}
	public void setNombreInstitucion(String nombreInstitucion) {
		this.nombreInstitucion = nombreInstitucion;
	}
	public String getClaveUsuario() {
		return claveUsuario;
	}
	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}
	public String getFechaSistema() {
		return fechaSistema;
	}
	public void setFechaSistema(String fechaSistema) {
		this.fechaSistema = fechaSistema;
	}
}
