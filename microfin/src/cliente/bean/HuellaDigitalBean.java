package cliente.bean;

import general.bean.BaseBean;

public class HuellaDigitalBean extends BaseBean {

	private String huellaDigitalID;
	private String tipoPersona;
	private String personaID;
	private byte[] huellaUno;
	private byte[] fmdHuellaUno;
	private String dedoHuellaUno;
	private byte[] huellaDos;
	private byte[] fmdHuellaDos;
	private String dedoHuellaDos;

	private String manoSeleccionada;
	private String dedoSeleccionado;
	private byte[] huella;
	private String origenDatos;

	private String permiteContrasenia;
	private String clave;
	private byte[] fidImagenHuella;
	private String nombreCompleto;
	private String usuarioID;
	private String sucursalID;
	private String estatus;

	// Validación de Huella Digital para Cliente / Firmantes
	private String cuentaAhoID;
	private String noHuellas;

	public String getHuellaDigitalID() {
		return huellaDigitalID;
	}
	public void setHuellaDigitalID(String huellaDigitalID) {
		this.huellaDigitalID = huellaDigitalID;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getPersonaID() {
		return personaID;
	}
	public void setPersonaID(String personaID) {
		this.personaID = personaID;
	}
	public String getDedoHuellaUno() {
		return dedoHuellaUno;
	}
	public void setDedoHuellaUno(String dedoHuellaUno) {
		this.dedoHuellaUno = dedoHuellaUno;
	}
	public String getDedoHuellaDos() {
		return dedoHuellaDos;
	}
	public void setDedoHuellaDos(String dedoHuellaDos) {
		this.dedoHuellaDos = dedoHuellaDos;
	}
	public byte[] getHuellaUno() {
		return huellaUno;
	}
	public void setHuellaUno(byte[] huellaUno) {
		this.huellaUno = huellaUno;
	}
	public byte[] getHuellaDos() {
		return huellaDos;
	}
	public void setHuellaDos(byte[] huellaDos) {
		this.huellaDos = huellaDos;
	}
	public String getManoSeleccionada() {
		return manoSeleccionada;
	}
	public void setManoSeleccionada(String manoSeleccionada) {
		this.manoSeleccionada = manoSeleccionada;
	}
	public String getDedoSeleccionado() {
		return dedoSeleccionado;
	}
	public void setDedoSeleccionado(String dedoSeleccionado) {
		this.dedoSeleccionado = dedoSeleccionado;
	}
	public byte[] getHuella() {
		return huella;
	}
	public void setHuella(byte[] huella) {
		this.huella = huella;
	}
	public String getOrigenDatos() {
		return origenDatos;
	}
	public void setOrigenDatos(String origenDatos) {
		this.origenDatos = origenDatos;
	}
	public String getPermiteContrasenia() {
		return permiteContrasenia;
	}
	public void setPermiteContrasenia(String permiteContrasenia) {
		this.permiteContrasenia = permiteContrasenia;
	}
	public String getClave() {
		return clave;
	}
	public void setClave(String clave) {
		this.clave = clave;
	}
	public byte[] getFidImagenHuella() {
		return fidImagenHuella;
	}
	public void setFidImagenHuella(byte[] fidImagenHuella) {
		this.fidImagenHuella = fidImagenHuella;
	}
	public String getNombreCompleto() {
		return nombreCompleto;
	}
	public void setNombreCompleto(String nombreCompleto) {
		this.nombreCompleto = nombreCompleto;
	}
	public String getUsuarioID() {
		return usuarioID;
	}
	public void setUsuarioID(String usuarioID) {
		this.usuarioID = usuarioID;
	}
	public String getSucursalID() {
		return sucursalID;
	}
	public void setSucursalID(String sucursalID) {
		this.sucursalID = sucursalID;
	}
	public String getCuentaAhoID() {
		return cuentaAhoID;
	}
	public void setCuentaAhoID(String cuentaAhoID) {
		this.cuentaAhoID = cuentaAhoID;
	}
	public String getNoHuellas() {
		return noHuellas;
	}
	public void setNoHuellas(String noHuellas) {
		this.noHuellas = noHuellas;
	}
	public String getEstatus() {
		return estatus;
	}
	public void setEstatus(String estatus) {
		this.estatus = estatus;
	}
	public byte[] getFmdHuellaUno() {
		return fmdHuellaUno;
	}
	public void setFmdHuellaUno(byte[] fmdHuellaUno) {
		this.fmdHuellaUno = fmdHuellaUno;
	}
	public byte[] getFmdHuellaDos() {
		return fmdHuellaDos;
	}
	public void setFmdHuellaDos(byte[] fmdHuellaDos) {
		this.fmdHuellaDos = fmdHuellaDos;
	}
}