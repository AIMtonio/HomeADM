package cuentas.bean;

import general.bean.BaseBean;

public class CuentasFirmaBean extends BaseBean{

	//Declaracion de Constantes
		public static int LONGITUD_ID = 11;

		private String cuentaFirmaID;
		private String cuentaAhoID;
		private String personaID;
		private String nombreCompleto;
		private String tipo;
		private String instrucEspecial;
		private String rfc;
		private String clienteID;
		private String esFirmante;
		private String sucursalID;

		//Para el Registro de la Huella Digital
		private String tipoFirmante;
		private byte[] huellaUno;
		private String dedoHuellaUno;
		private byte[] huellaDos;
		private String dedoHuellaDos;
		private String estatus;


		public String getCuentaFirmaID() {
			return cuentaFirmaID;
		}
		public void setCuentaFirmaID(String cuentaFirmaID) {
			this.cuentaFirmaID = cuentaFirmaID;
		}
		public String getCuentaAhoID() {
			return cuentaAhoID;
		}
		public void setCuentaAhoID(String cuentaAhoID) {
			this.cuentaAhoID = cuentaAhoID;
		}
		public String getPersonaID() {
			return personaID;
		}
		public void setPersonaID(String personaID) {
			this.personaID = personaID;
		}
		public String getNombreCompleto() {
			return nombreCompleto;
		}
		public void setNombreCompleto(String nombreCompleto) {
			this.nombreCompleto = nombreCompleto;
		}
		public String getTipo() {
			return tipo;
		}
		public void setTipo(String tipo) {
			this.tipo = tipo;
		}
		public String getInstrucEspecial() {
			return instrucEspecial;
		}
		public void setInstrucEspecial(String instrucEspecial) {
			this.instrucEspecial = instrucEspecial;
		}
		public String getRfc() {
			return rfc;
		}
		public void setRfc(String rfc) {
			this.rfc = rfc;
		}
		public String getClienteID() {
			return clienteID;
		}
		public void setClienteID(String clienteID) {
			this.clienteID = clienteID;
		}
		public String getEsFirmante() {
			return esFirmante;
		}
		public void setEsFirmante(String esFirmante) {
			this.esFirmante = esFirmante;
		}
		public String getTipoFirmante() {
			return tipoFirmante;
		}
		public void setTipoFirmante(String tipoFirmante) {
			this.tipoFirmante = tipoFirmante;
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
		public String getSucursalID() {
			return sucursalID;
		}
		public void setSucursalID(String sucursalID) {
			this.sucursalID = sucursalID;
		}
		public String getEstatus() {
			return estatus;
		}
		public void setEstatus(String estatus) {
			this.estatus = estatus;
		}

}
