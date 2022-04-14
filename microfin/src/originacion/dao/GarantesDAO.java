package originacion.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import originacion.bean.GarantesBean;

public class GarantesDAO extends BaseDAO{

	public GarantesDAO() {
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";
	// ------------------ Transacciones ------------------------------------------

	/* Alta del Cliente */
	public MensajeTransaccionBean altaGarante(final GarantesBean garante, final GarantesBean garanteBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call GARANTESALT(" +
										"?,?,?,?,?, ?,?,?,?,?,       " +
										"?,?,?,?,?, ?,?,?,?,?,       " +
										"?,?,?,?,?, ?,?,?,?,?,       " +
										"?,?,?,?,?,	?,?,?,?,?,       " +
										"?,?,?,?,?,	?,?,?,?,?,       " +
										"?,?,?,?,?,	?,?,?,?,?,       " +
										"?,?,?,?,?,	?,?,?,?,?,       " +
										"?,?,?,?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoPersona",garante.getTipoPersona());
									sentenciaStore.setString("Par_Titulo",garante.getTitulo());
									sentenciaStore.setString("Par_PrimerNombre",garante.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNombre",garante.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNombre",garante.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPaterno",garante.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMaterno",garante.getApellidoMaterno());
									sentenciaStore.setDate("Par_FechaNacimiento",herramientas.OperacionesFechas.conversionStrDate(garante.getFechaNacimiento()));
									sentenciaStore.setString("Par_Nacionalidad",garanteBean.getNacionalidad());
									sentenciaStore.setInt("Par_LugarNacimiento",Utileria.convierteEntero(garante.getLugarNacimiento()));

									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(garante.getEstadoID()));
									sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(garante.getPaisResidencia()));
									sentenciaStore.setString("Par_Sexo",garante.getSexo());
									sentenciaStore.setString("Par_CURP",garante.getCurp());
									sentenciaStore.setString("Par_RegistroHacienda",garante.getRegistroHacienda());
									sentenciaStore.setString("Par_RFC",garante.getRfc());
									sentenciaStore.setDate("Par_FechaConstitucion",herramientas.OperacionesFechas.conversionStrDate(garanteBean.getFechaConstitucion()));
									sentenciaStore.setString("Par_EstadoCivil",garante.getEstadoCivil());
									sentenciaStore.setString("Par_TelefonoCel",garante.getTelefonoCelular());
									sentenciaStore.setString("Par_Telefono",garanteBean.getTelefono());

									sentenciaStore.setString("Par_ExtTelefonoPart",garanteBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_Correo",garanteBean.getCorreo());
									sentenciaStore.setString("Par_Fax",garante.getFax());
									sentenciaStore.setString("Par_Observaciones",garante.getObservaciones());
									sentenciaStore.setString("Par_RazonSocial",garante.getRazonSocial());
									sentenciaStore.setString("Par_RFCpm",garante.getRfcPM());
									sentenciaStore.setInt("Par_PaisConstitucionID",Utileria.convierteEntero(garante.getPaisConstitucionID()));
									sentenciaStore.setString("Par_CorreoAlterPM",garante.getCorreoAlternativo());
									sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(garante.getTipoSociedad()));
									sentenciaStore.setInt("Par_GrupoEmp",Utileria.convierteEntero(garante.getGrupoEmpresarial()));

									sentenciaStore.setString("Par_FEA",garante.getFea());
									sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(garante.getPaisFEA()));
									sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(garante.getTipoIdentiID()));
									sentenciaStore.setString("Par_NumIndentif",garante.getNumIdentific());
									sentenciaStore.setString("Par_FecExIden",Utileria.convierteFecha(garante.getFecExIden()));
									sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(garante.getFecVenIden()));
									sentenciaStore.setInt("Par_EstadoIDCli", Utileria.convierteEntero(garante.getEstadoIDDir()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(garante.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(garante.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(garante.getColoniaID()));

									sentenciaStore.setString("Par_Calle", garante.getCalle());
									sentenciaStore.setString("Par_NumeroCasa", garante.getNumeroCasa());
									sentenciaStore.setString("Par_NumInterior", garante.getNumInterior());
									sentenciaStore.setString("Par_CP", garante.getCP());
									sentenciaStore.setString("Par_Lote", garante.getLote());
									sentenciaStore.setString("Par_Manzana", garante.getManzana());
									sentenciaStore.setString("Par_Esc_Tipo",garante.getEsc_Tipo());
									sentenciaStore.setString("Par_EscriPub",garante.getEscrituraPub());
									sentenciaStore.setString("Par_LibroEscr",garante.getLibroEscritura());
									sentenciaStore.setString("Par_VolumenEsc",garante.getVolumenEsc());

									sentenciaStore.setString("Par_FechaEsc",Utileria.convierteFecha(garante.getFechaEsc()));
									sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(garante.getEstadoIDEsc()));
									sentenciaStore.setInt("Par_MunicipioEsc",Utileria.convierteEntero(garante.getMunicipioEsc()));
									sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(garante.getNotaria()));
									sentenciaStore.setString("Par_NomApoder",garante.getNomApoderado());
									sentenciaStore.setString("Par_RFC_Apoder",garante.getRFC_Apoderado());
									sentenciaStore.setString("Par_RegistroPub",garante.getRegistroPub());
									sentenciaStore.setString("Par_FolioRegPub",garante.getFolioRegPub());
									sentenciaStore.setString("Par_VolRegPub",garante.getVolumenRegPub());
									sentenciaStore.setString("Par_LibroRegPub",garante.getLibroRegPub());

									sentenciaStore.setString("Par_AuxiRegPub",garante.getAuxiliarRegPub());
									sentenciaStore.setString("Par_FechaRegPub",Utileria.convierteFecha(garante.getFechaRegPub()));
									sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(garante.getEstadoIDReg()));
									sentenciaStore.setInt("Par_MunicipioRegPub",Utileria.convierteEntero(garante.getMunicipioRegPub()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_GaranteID", Types.INTEGER);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .GarantesDAO.altaGarante");
						} if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());

						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Garante" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	/* Modificacion del Cliente */
	public MensajeTransaccionBean modificaGarante(final GarantesBean garante, final GarantesBean garanteBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
//
									String query = "call GARANTESMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_GaranteID",Utileria.convierteEntero(garante.getNumero()));
									sentenciaStore.setString("Par_TipoPersona",garante.getTipoPersona());
									sentenciaStore.setString("Par_Titulo",garante.getTitulo());
									sentenciaStore.setString("Par_PrimerNombre",garante.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNombre",garante.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNombre",garante.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPaterno",garante.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMaterno",garante.getApellidoMaterno());
									sentenciaStore.setDate("Par_FechaNacimiento",herramientas.OperacionesFechas.conversionStrDate(garante.getFechaNacimiento()));
									sentenciaStore.setString("Par_Nacionalidad",garanteBean.getNacionalidad());

									sentenciaStore.setInt("Par_LugarNacimiento",Utileria.convierteEntero(garante.getLugarNacimiento()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(garante.getEstadoID()));
									sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(garante.getPaisResidencia()));
									sentenciaStore.setString("Par_Sexo",garante.getSexo());
									sentenciaStore.setString("Par_CURP",garante.getCurp());
									sentenciaStore.setString("Par_RegistroHacienda",garante.getRegistroHacienda());
									sentenciaStore.setString("Par_RFC",garante.getRfc());
									sentenciaStore.setDate("Par_FechaConstitucion",herramientas.OperacionesFechas.conversionStrDate(garanteBean.getFechaConstitucion()));
									sentenciaStore.setString("Par_EstadoCivil",garante.getEstadoCivil());
									sentenciaStore.setString("Par_TelefonoCel",garante.getTelefonoCelular());

									sentenciaStore.setString("Par_Telefono",garanteBean.getTelefono());
									sentenciaStore.setString("Par_ExtTelefonoPart",garanteBean.getExtTelefonoPart());
									sentenciaStore.setString("Par_Correo",garanteBean.getCorreo());
									sentenciaStore.setString("Par_Fax",garante.getFax());
									sentenciaStore.setString("Par_Observaciones",garante.getObservaciones());
									sentenciaStore.setString("Par_RazonSocial",garante.getRazonSocial());
									sentenciaStore.setString("Par_RFCpm",garante.getRfcPM());
									sentenciaStore.setInt("Par_PaisConstitucionID",Utileria.convierteEntero(garante.getPaisConstitucionID()));
									sentenciaStore.setString("Par_CorreoAlterPM",garante.getCorreoAlternativo());
									sentenciaStore.setInt("Par_TipoSocID",Utileria.convierteEntero(garante.getTipoSociedad()));

									sentenciaStore.setInt("Par_GrupoEmp",Utileria.convierteEntero(garante.getGrupoEmpresarial()));
									sentenciaStore.setString("Par_FEA",garante.getFea());
									sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(garante.getPaisFEA()));
									sentenciaStore.setInt("Par_TipoIdentID",Utileria.convierteEntero(garante.getTipoIdentiID()));
									sentenciaStore.setString("Par_NumIndentif",garante.getNumIdentific());
									sentenciaStore.setDate("Par_FecExIden",OperacionesFechas.conversionStrDate(garante.getFecExIden()));
									sentenciaStore.setDate("Par_FecVenIden",OperacionesFechas.conversionStrDate(garante.getFecVenIden()));
									sentenciaStore.setInt("Par_EstadoIDCli", Utileria.convierteEntero(garante.getEstadoIDDir()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(garante.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(garante.getLocalidadID()));

									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(garante.getColoniaID()));
									sentenciaStore.setString("Par_Calle", garante.getCalle());
									sentenciaStore.setString("Par_NumeroCasa", garante.getNumeroCasa());
									sentenciaStore.setString("Par_NumInterior", garante.getNumInterior());
									sentenciaStore.setString("Par_CP", garante.getCP());
									sentenciaStore.setString("Par_Lote", garante.getLote());
									sentenciaStore.setString("Par_Manzana", garante.getManzana());
									sentenciaStore.setString("Par_Esc_Tipo",garante.getEsc_Tipo());
									sentenciaStore.setString("Par_EscriPub",garante.getEscrituraPub());
									sentenciaStore.setString("Par_LibroEscr",garante.getLibroEscritura());

									sentenciaStore.setString("Par_VolumenEsc",garante.getVolumenEsc());
									sentenciaStore.setString("Par_FechaEsc",Utileria.convierteFecha(garante.getFechaEsc()));
									sentenciaStore.setInt("Par_EstadoIDEsc",Utileria.convierteEntero(garante.getEstadoIDEsc()));
									sentenciaStore.setInt("Par_MunicipioEsc",Utileria.convierteEntero(garante.getMunicipioEsc()));
									sentenciaStore.setInt("Par_Notaria",Utileria.convierteEntero(garante.getNotaria()));
									sentenciaStore.setString("Par_NomApoder",garante.getNomApoderado());
									sentenciaStore.setString("Par_RFC_Apoder",garante.getRFC_Apoderado());
									sentenciaStore.setString("Par_RegistroPub",garante.getRegistroPub());
									sentenciaStore.setString("Par_FolioRegPub",garante.getFolioRegPub());
									sentenciaStore.setString("Par_VolRegPub",garante.getVolumenRegPub());

									sentenciaStore.setString("Par_LibroRegPub",garante.getLibroRegPub());
									sentenciaStore.setString("Par_AuxiRegPub",garante.getAuxiliarRegPub());
									sentenciaStore.setString("Par_FechaRegPub",Utileria.convierteFecha(garante.getFechaRegPub()));
									sentenciaStore.setInt("Par_EstadoIDReg",Utileria.convierteEntero(garante.getEstadoIDReg()));
									sentenciaStore.setInt("Par_MunicipioRegPub",Utileria.convierteEntero(garante.getMunicipioRegPub()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GarantesDAO.modificaGarante");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .GarantesDAO.modificaGarante");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Garante: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Garante" + e);
						e.printStackTrace();
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		/* Consuta Cliente por Llave Principal*/
		public GarantesBean consultaPrincipal(int garanteID, int tipoConsulta) {
		GarantesBean garantesBean = null;
		try{
			//Query con el Store Procedure
			String query = "call GARANTESCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	garanteID,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"GarantesDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GARANTESCON(" + Arrays.toString(parametros) + ")");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								GarantesBean garante = new GarantesBean();
								garante.setNumero(resultSet.getString("GaranteID"));
								garante.setTipoPersona(resultSet.getString("TipoPersona"));
								garante.setTitulo(resultSet.getString("Titulo"));
								garante.setPrimerNombre(resultSet.getString("PrimerNombre"));
								garante.setSegundoNombre(resultSet.getString("SegundoNombre"));
								garante.setTercerNombre(resultSet.getString("TercerNombre"));
								garante.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
								garante.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
								garante.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
								garante.setNacionalidad(resultSet.getString("Nacion"));
								garante.setLugarNacimiento(resultSet.getString("LugarNacimiento"));
								garante.setEstadoID(resultSet.getString("EstadoID"));
								garante.setPaisResidencia(resultSet.getString("PaisResidencia"));
								garante.setSexo(resultSet.getString("Sexo"));
								garante.setCurp(resultSet.getString("CURP"));
								garante.setRegistroHacienda(resultSet.getString("RegistroHacienda"));
								garante.setRfc(resultSet.getString("RFC"));
								garante.setFechaConstitucion(resultSet.getString("FechaConstitucion"));
								garante.setEstadoCivil(resultSet.getString("EstadoCivil"));
								garante.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
								garante.setTelefono(resultSet.getString("Telefono"));
								garante.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
								garante.setCorreo(resultSet.getString("Correo"));
								garante.setFax(resultSet.getString("Fax"));
								garante.setObservaciones(resultSet.getString("Observaciones"));
								garante.setRazonSocial(resultSet.getString("RazonSocial"));
								garante.setRfcPM(resultSet.getString("RFCpm"));
								garante.setPaisConstitucionID(resultSet.getString("PaisConstitucionID"));
								garante.setCorreoAlternativo(resultSet.getString("CorreoAlterPM"));
								garante.setTipoSociedad(resultSet.getString("TipoSociedadID"));
								garante.setGrupoEmpresarial(resultSet.getString("GrupoEmpresarial"));

								garante.setFea(resultSet.getString("FEA"));
								garante.setPaisFEA(resultSet.getString("PaisFEA"));
								garante.setTipoIdentiID(resultSet.getString("TipoIdentiID"));
								garante.setNumIdentific(resultSet.getString("NumIdentific"));
								garante.setFecExIden(resultSet.getString("FecExIden"));
								garante.setFecVenIden(resultSet.getString("FecVenIden"));
								garante.setEstadoIDDir(resultSet.getString("EstadoIDDir"));
								garante.setMunicipioID(resultSet.getString("MunicipioID"));
								garante.setLocalidadID(resultSet.getString("LocalidadID"));
								garante.setColoniaID(resultSet.getString("ColoniaID"));
								garante.setCalle(resultSet.getString("Calle"));
								garante.setNumeroCasa(resultSet.getString("NumeroCasa"));
								garante.setNumInterior(resultSet.getString("NumInterior"));
								garante.setCP(resultSet.getString("CP"));
								garante.setLote(resultSet.getString("Lote"));
								garante.setManzana(resultSet.getString("Manzana"));
								garante.setEsc_Tipo(resultSet.getString("Esc_Tipo"));
								garante.setEscrituraPub(resultSet.getString("EscrituraPublic"));
								garante.setLibroEscritura(resultSet.getString("LibroEscritura"));
								garante.setVolumenEsc(resultSet.getString("VolumenEsc"));
								garante.setFechaEsc(resultSet.getString("FechaEsc"));
								garante.setEstadoIDEsc(resultSet.getString("EstadoIDEsc"));
								garante.setMunicipioEsc(resultSet.getString("MunicipioEsc"));
								garante.setNotaria(resultSet.getString("Notaria"));
								garante.setNomApoderado(resultSet.getString("NomApoderado"));
								garante.setRFC_Apoderado(resultSet.getString("RFC_Apoderado"));
								garante.setRegistroPub(resultSet.getString("RegistroPub"));
								garante.setFolioRegPub(resultSet.getString("FolioRegPub"));
								garante.setVolumenRegPub(resultSet.getString("VolumenRegPub"));
								garante.setLibroRegPub(resultSet.getString("LibroRegPub"));
								garante.setAuxiliarRegPub(resultSet.getString("AuxiliarRegPub"));
								garante.setFechaRegPub(resultSet.getString("FechaRegPub"));
								garante.setEstadoIDReg(resultSet.getString("EstadoIDReg"));
								garante.setMunicipioRegPub(resultSet.getString("MunicipioRegPub"));
								garante.setNombreCompleto(resultSet.getString("NombreCompleto"));




							return garante;

						}
			});
			garantesBean= matches.size() > 0 ? (GarantesBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de garantes", e);

		}
		return garantesBean;
		}



		/* Consuta Cliente por Llave Principal*/
		public GarantesBean consultaGarantePF(int garanteID, int tipoConsulta) {
		GarantesBean garantesBean = null;
		try{
			//Query con el Store Procedure
			String query = "call GARANTESCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	garanteID,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"GarantesDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GARANTESCON(" + Arrays.toString(parametros) + ")");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								GarantesBean garante = new GarantesBean();
								garante.setNumero(resultSet.getString("GaranteID"));
								garante.setNombreCompleto(resultSet.getString("NombreCompleto"));




							return garante;

						}
			});
			garantesBean= matches.size() > 0 ? (GarantesBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de garantes", e);

		}
		return garantesBean;
		}

	/* Lista de Garantes por Nombre */
	public List listaPrincipal(GarantesBean garantesBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call GARANTESLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	garantesBean.getNombreCompleto(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GARANTESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GarantesBean garante = new GarantesBean();
				garante.setNumero(resultSet.getString("GaranteID"));
				garante.setNombreCompleto(resultSet.getString("NombreCompleto"));

				return garante;
			}
		});
		return matches;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}