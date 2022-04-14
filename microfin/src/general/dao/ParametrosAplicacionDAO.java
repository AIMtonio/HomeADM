package general.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.ParametrosSesionBean;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.bean.ConexionOrigenDatosBean;
import soporte.bean.UsuarioBean;

public class ParametrosAplicacionDAO{
	private JdbcTemplate jdbcTemplate;
	private ConexionOrigenDatosBean conexionOrigenDatosBean=null;

	public ParametrosAplicacionDAO() {
		super();
		
	}	
	
	/* Consulta Parametros de Session en el Login o Entrada */ 
	public ParametrosSesionBean consultaParaSession(UsuarioBean usuarioBean, int tipoConsulta){
		String query = "call PARAMETROSSISCON(?,?,?," +
												"?,?,?," +
												"?,?,?);";
		Object[] parametros = { 
				Constantes.ENTERO_CERO,
				usuarioBean.getClave(),
				tipoConsulta,	
				
				Constantes.ENTERO_CERO,//aud_usuario
				Constantes.FECHA_VACIA, //fechaActual
				Constantes.STRING_VACIO,// direccionIP
				Constantes.STRING_VACIO, //programaID
				Constantes.ENTERO_CERO,// sucursal
				Constantes.ENTERO_CERO
								};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				ParametrosSesionBean sesionBean = new ParametrosSesionBean();
				
				sesionBean.setFechaAplicacion(resultSet.getDate(1));
				sesionBean.setNumeroSucursalMatriz(resultSet.getInt(2));
				sesionBean.setNombreSucursalMatriz(resultSet.getString(3));
				sesionBean.setTelefonoLocal(resultSet.getString(4));
				sesionBean.setTelefonoInterior(resultSet.getString(5));
				sesionBean.setNumeroInstitucion(resultSet.getInt(6));
				sesionBean.setNombreInstitucion(resultSet.getString(7));
				sesionBean.setRepresentanteLegal(resultSet.getString(8));
				sesionBean.setRfcRepresentante(resultSet.getString(9));
				sesionBean.setNumeroMonedaBase(resultSet.getInt(10));
				sesionBean.setNombreMonedaBase(resultSet.getString(11));
				sesionBean.setDesCortaMonedaBase(resultSet.getString(12));
				sesionBean.setSimboloMonedaBase(resultSet.getString(13));
				sesionBean.setNumeroUsuario(resultSet.getInt(14));
				sesionBean.setClaveUsuario(resultSet.getString(15));
				sesionBean.setPerfilUsuario(resultSet.getInt(16));
				sesionBean.setNombreUsuario(resultSet.getString(17));
				sesionBean.setCorreoUsuario(resultSet.getString(18));
				sesionBean.setSucursal(resultSet.getInt(19));
				sesionBean.setFechaSucursal(resultSet.getDate(20));
				sesionBean.setNombreSucursal(resultSet.getString(21));
				sesionBean.setGerenteSucursal(resultSet.getString(22));
				sesionBean.setTasaISR(resultSet.getFloat(23));				
				sesionBean.setEmpresaID(resultSet.getInt(24));
				sesionBean.setDiasBaseInversion(resultSet.getInt(25));
				sesionBean.setFechUltimAcces(resultSet.getDate(26));
				sesionBean.setFechUltPass(resultSet.getDate(27));
				sesionBean.setCambioPassword(resultSet.getString(28));
				sesionBean.setEstatusSesion(resultSet.getString(29));
				sesionBean.setIPsesion(resultSet.getString(30));
				sesionBean.setPromotorID(resultSet.getInt(32));
				sesionBean.setClienteInstitucion(resultSet.getInt(33));
				sesionBean.setCuentaInstitucion(resultSet.getLong(34));
				sesionBean.setRutaArchivos(resultSet.getString(35));
				sesionBean.setCajaID(resultSet.getString(36));
				sesionBean.setTipoCaja(resultSet.getString(37));
				sesionBean.setSaldoEfecMN(resultSet.getString(38));
				sesionBean.setSaldoEfecME(resultSet.getString(39));	
				sesionBean.setLimiteEfectivoMN(resultSet.getString(40));
				sesionBean.setTipoCajaDes(resultSet.getString(41));	
				sesionBean.setClavePuestoID(resultSet.getString(42));
				sesionBean.setRutaArchivosPLD(resultSet.getString(43));	
				sesionBean.setIvaSucursal(resultSet.getFloat(44));	
				sesionBean.setDireccionInstitucion(resultSet.getString(45));
				sesionBean.setEdoMunSucursal(resultSet.getString(46));
				sesionBean.setImpTicket(resultSet.getString(47));	
				sesionBean.setTipoImpTicket(resultSet.getString(48));
				sesionBean.setEstatusCaja(resultSet.getString(49));
				sesionBean.setMontoAportacion(resultSet.getDouble(50));
				sesionBean.setMontoPolizaSegA(resultSet.getDouble(51));
				sesionBean.setMontoSegAyuda(resultSet.getDouble(52));				
				sesionBean.setNomCortoInstitucion(resultSet.getString(53));				
				sesionBean.setSalMinDF(resultSet.getDouble("SalMinDF"));
				sesionBean.setDirFiscal(resultSet.getString(55));	
				sesionBean.setRfcInst(resultSet.getString(56));
				sesionBean.setNombreJefeCobranza(resultSet.getString("JefeCobranza"));
				sesionBean.setNomJefeOperayPromo(resultSet.getString("JefeOperaPromo"));
				sesionBean.setImpSaldoCred(resultSet.getString(57));	
				sesionBean.setImpSaldoCta(resultSet.getString(58));
				sesionBean.setNombreCortoInst(resultSet.getString("NombreCortoInst"));
				sesionBean.setRolTesoreria(resultSet.getString("RolTesoreria"));//obteniendo rol tesoreria
				sesionBean.setRolAdminTeso(resultSet.getString("RolAdminTeso"));//obteniendo rolAdminTesoreria
				sesionBean.setMostrarSaldDisCtaYSbc(resultSet.getString("MostrarSaldDisCtaYSbc"));//obteniendo valor de mostrar saldo disponible en cta
							
				sesionBean.setGerenteGeneral(resultSet.getString("GerenteGeneral"));
				sesionBean.setPresidenteConsejo(resultSet.getString("PresidenteConsejo"));
				sesionBean.setJefeContabilidad(resultSet.getString("JefeContabilidad"));
				sesionBean.setRecursoTicketVent(resultSet.getString("RecursoTicketVent"));
				sesionBean.setFuncionHuella(resultSet.getString("FuncionHuella"));
				sesionBean.setMostrarPrefijo(resultSet.getString("MostrarPrefijo"));
				sesionBean.setCambiaPromotor(resultSet.getString("CambiaPromotor"));
				sesionBean.setLogoCtePantalla(resultSet.getString("LogoCtePantalla"));
				sesionBean.setTipoImpresoraTicket(resultSet.getString("TipoImpresoraTicket"));
				sesionBean.setDirectorFinanzas(resultSet.getString("DirectorFinanzas"));
				sesionBean.setMostrarBtnResumen(resultSet.getString("MostrarBtnResumen"));
				sesionBean.setLookAndFeel(resultSet.getString("LookAndFeel"));
				return sesionBean;
			}
		});
		ParametrosSesionBean parametrosSesionBean = matches.size() > 0 ? (ParametrosSesionBean) matches.get(0) : null; 
		parametrosSesionBean.setOrigenDatos(usuarioBean.getOrigenDatos());		
		parametrosSesionBean.setRutaReportes(usuarioBean.getRutaReportes());		
		parametrosSesionBean.setRutaImgReportes(usuarioBean.getRutaImgReportes());	
		return parametrosSesionBean;
		
	}
	
	/* Consulta Parametros del cliente y cuenta de la institucion*/
	/* se usa en la creacion del credito*/
	public ParametrosSesionBean consultaCteCtaWS(UsuarioBean usuarioBean, int tipoConsulta){
		String query = "call PARAMETROSSISCON(?,?);";
		Object[] parametros = { usuarioBean.getClave(),
								tipoConsulta	};
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosSesionBean sesionBean = new ParametrosSesionBean();
				sesionBean.setClienteInstitucion(resultSet.getInt(1));
				sesionBean.setCuentaInstitucion(resultSet.getInt(2));
				sesionBean.setFechaAplicacion(resultSet.getDate(3));
				return sesionBean;
			}
		});
		return matches.size() > 0 ? (ParametrosSesionBean) matches.get(0) : null;
	}
	
	/* Consulta Fecha de sistema de la sucursal tony*/
	/* se usa para los movimientos que se hacen en ventanilla*/
	
	public ParametrosSesionBean consultaFechaSucursal(int sucursalID, int tipoConsulta,String origenDatos){

		String query = "call PARAMETROSSISCON(?,?,?,?,?, ?,?,?,?);";

		Object[] parametros = {Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,								
								tipoConsulta,
								
								Constantes.ENTERO_CERO,//aud_usuario
								Constantes.FECHA_VACIA, //fechaActual
								Constantes.STRING_VACIO,// direccionIP
								Constantes.STRING_VACIO, //programaID
								sucursalID,// sucursal
								Constantes.ENTERO_CERO
								};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosSesionBean sessionbean = new ParametrosSesionBean();
				sessionbean.setFechaSucursal(resultSet.getDate("FechaSucursal"));
				sessionbean.setFechaAplicacion(resultSet.getDate("FechaSistema"));			
				return sessionbean;
			}
		});
		return matches.size() > 0 ? (ParametrosSesionBean) matches.get(0) : null;
	}
	

	// Consulta de Representantes Financieros
	public ParametrosSesionBean consultaReporteFinanciero(final ParametrosSesionBean parametrosSesionBean, final String origenDatos, final int tipoConsulta){
		ParametrosSesionBean parametrosSistema = null;
		Logger loggerSAFI = Logger.getLogger("SAFI");
		try{
			String query = "CALL PARAMETROSSISCON(?,?,?,?,?, ?,?,?,?);";
	
			Object[] parametros = { 
					parametrosSesionBean.getEmpresaID(),
					Constantes.STRING_VACIO,								
					tipoConsulta,
					
					Constantes.ENTERO_CERO,//aud_usuario
					Constantes.FECHA_VACIA, //fechaActual
					Constantes.STRING_VACIO,// direccionIP
					Constantes.STRING_VACIO, //programaID
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(origenDatos+"-"+"CALL PARAMETROSSISCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParametrosSesionBean sessionbean = new ParametrosSesionBean();
					sessionbean.setGerenteGeneral(resultSet.getString("GerenteGeneral"));
					sessionbean.setJefeContabilidad(resultSet.getString("JefeContabilidad"));
					sessionbean.setPresidenteConsejo(resultSet.getString("PresidenteConsejo"));
					sessionbean.setDirectorFinanzas(resultSet.getString("DirectorFinanzas"));
					return sessionbean;
				}
			});
			
			parametrosSistema = matches.size() > 0 ? (ParametrosSesionBean) matches.get(0) : null;
			
		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
		}
		return parametrosSistema;
	}
		
	/** Seters y Getters **/	
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}


	public ConexionOrigenDatosBean getConexionOrigenDatosBean() {
		return conexionOrigenDatosBean;
	}

	public void setConexionOrigenDatosBean(
			ConexionOrigenDatosBean conexionOrigenDatosBean) {
		this.conexionOrigenDatosBean = conexionOrigenDatosBean;
	}

	
	
}
