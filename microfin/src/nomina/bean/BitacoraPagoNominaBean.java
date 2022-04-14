package nomina.bean;

import org.springframework.web.multipart.MultipartFile;

import general.bean.BaseBean;

public class BitacoraPagoNominaBean extends BaseBean{
	private String creditoID;
	private String clienteID;
	private String montoPagos;
	private String fechaInicio;
	private String institNominaID;
	private String folioCargaID;
	private String folioCargaIDBE;
	private String numTotalPagos;
	private String numPagosExito;
	private String numPagosError;
	private String rutaArchivosPagos;
	private String fechaCarga;
	private String claveUsuario;
	private String folioNominaID;
	private String correoElectronico;
	private String nombreInstit;

	
	private MultipartFile file;

	public String getCreditoID() {
		return creditoID;
	}

	public void setCreditoID(String creditoID) {
		this.creditoID = creditoID;
	}

	public String getClienteID() {
		return clienteID;
	}

	public void setClienteID(String clienteID) {
		this.clienteID = clienteID;
	}

	public String getMontoPagos() {
		return montoPagos;
	}

	public void setMontoPagos(String montoPagos) {
		this.montoPagos = montoPagos;
	}

	public String getFechaInicio() {
		return fechaInicio;
	}

	public void setFechaInicio(String fechaInicio) {
		this.fechaInicio = fechaInicio;
	}

	public String getInstitNominaID() {
		return institNominaID;
	}

	public void setInstitNominaID(String institNominaID) {
		this.institNominaID = institNominaID;
	}

	public String getFolioCargaID() {
		return folioCargaID;
	}

	public void setFolioCargaID(String folioCargaID) {
		this.folioCargaID = folioCargaID;
	}

	public String getFolioCargaIDBE() {
		return folioCargaIDBE;
	}

	public void setFolioCargaIDBE(String folioCargaIDBE) {
		this.folioCargaIDBE = folioCargaIDBE;
	}

	public String getNumTotalPagos() {
		return numTotalPagos;
	}

	public void setNumTotalPagos(String numTotalPagos) {
		this.numTotalPagos = numTotalPagos;
	}

	public String getNumPagosExito() {
		return numPagosExito;
	}

	public void setNumPagosExito(String numPagosExito) {
		this.numPagosExito = numPagosExito;
	}

	public String getNumPagosError() {
		return numPagosError;
	}

	public void setNumPagosError(String numPagosError) {
		this.numPagosError = numPagosError;
	}

	public String getRutaArchivosPagos() {
		return rutaArchivosPagos;
	}

	public void setRutaArchivosPagos(String rutaArchivosPagos) {
		this.rutaArchivosPagos = rutaArchivosPagos;
	}

	public String getFechaCarga() {
		return fechaCarga;
	}

	public void setFechaCarga(String fechaCarga) {
		this.fechaCarga = fechaCarga;
	}

	public String getClaveUsuario() {
		return claveUsuario;
	}

	public void setClaveUsuario(String claveUsuario) {
		this.claveUsuario = claveUsuario;
	}

	public String getFolioNominaID() {
		return folioNominaID;
	}

	public void setFolioNominaID(String folioNominaID) {
		this.folioNominaID = folioNominaID;
	}

	public String getCorreoElectronico() {
		return correoElectronico;
	}

	public void setCorreoElectronico(String correoElectronico) {
		this.correoElectronico = correoElectronico;
	}

	public MultipartFile getFile() {
		return file;
	}

	public void setFile(MultipartFile file) {
		this.file = file;
	}

	public String getNombreInstit() {
		return nombreInstit;
	}

	public void setNombreInstit(String nombreInstit) {
		this.nombreInstit = nombreInstit;
	}
	
}
	
	
	