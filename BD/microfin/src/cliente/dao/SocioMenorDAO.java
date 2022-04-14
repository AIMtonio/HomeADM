package cliente.dao;

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

import cliente.bean.SocioMenorBean;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SocioMenorDAO extends BaseDAO{


	public SocioMenorDAO(){
		super();
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";
	//Alta Socio Menor
	public MensajeTransaccionBean altaSocioMenor(final SocioMenorBean cliente) {
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
								cliente.setTelefonoCelular(cliente.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								cliente.setTelefonoCasa(cliente.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
									String query = "call SOCIOMENORALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(cliente.getSucursalOrigen()));
									sentenciaStore.setString("Par_TipoPersona",cliente.getTipoPersona());
									sentenciaStore.setString("Par_Titulo",cliente.getTitulo());
									sentenciaStore.setString("Par_PrimerNom",cliente.getPrimerNombre());
									sentenciaStore.setString("Par_SegundoNom",cliente.getSegundoNombre());
									sentenciaStore.setString("Par_TercerNom",cliente.getTercerNombre());
									sentenciaStore.setString("Par_ApellidoPat",cliente.getApellidoPaterno());
									sentenciaStore.setString("Par_ApellidoMat",cliente.getApellidoMaterno());
									sentenciaStore.setString("Par_FechaNac",cliente.getFechaNacimiento());
									sentenciaStore.setInt("Par_LugarNac",Utileria.convierteEntero(cliente.getLugarNacimiento()));

									sentenciaStore.setInt("Par_estadoID",Utileria.convierteEntero(cliente.getEstadoID()));
									sentenciaStore.setString("Par_Nacion",cliente.getNacion());
									sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(cliente.getPaisResidencia()));
									sentenciaStore.setString("Par_Sexo",cliente.getSexo());
									sentenciaStore.setString("Par_CURP",cliente.getCURP());
									sentenciaStore.setString("Par_RFC",Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_EstadoCivil",cliente.getEstadoCivil());
									sentenciaStore.setString("Par_TelefonoCel",cliente.getTelefonoCelular());
									sentenciaStore.setString("Par_Telefono",cliente.getTelefonoCasa());
									sentenciaStore.setString("Par_Correo",cliente.getCorreo());

									sentenciaStore.setString("Par_RazonSocial",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_TipoSocID",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_RFCpm",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_GrupoEmp",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Fax",Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(cliente.getOcupacionID()));
									sentenciaStore.setString("Par_Puesto",Constantes.STRING_VACIO);
									sentenciaStore.setString("Par_LugardeTrab",Constantes.STRING_VACIO);
									sentenciaStore.setFloat("Par_AntTra",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_TelTrabajo",Constantes.STRING_VACIO);

									sentenciaStore.setString("Par_Clasific",cliente.getClasificacion());
									sentenciaStore.setString("Par_MotivoApert",cliente.getMotivoApertura());
									sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
									sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());
									sentenciaStore.setString("Par_PagaIDE",cliente.getPagaIDE());
									sentenciaStore.setString("Par_NivelRiesgo",cliente.getNivelRiesgo());
									sentenciaStore.setInt("Par_SecGeneral",Utileria.convierteEntero(cliente.getSectorGeneral()));
									sentenciaStore.setString("Par_ActBancoMX",cliente.getActividadBancoMX());
									sentenciaStore.setInt("Par_ActINEGI",Utileria.convierteEntero(cliente.getActividadINEGI()));
									sentenciaStore.setInt("Par_SecEconomic",Utileria.convierteEntero(cliente.getSectorEconomico()));

									sentenciaStore.setString("Par_ActFR",cliente.getActividadFR());
									sentenciaStore.setInt("Par_ActFOMUR",Utileria.convierteEntero(cliente.getActividadFOMUR()));
									sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(cliente.getPromotorInicial()));
									sentenciaStore.setInt("Par_PromotorActual",Utileria.convierteEntero(cliente.getPromotorActual()));
									sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(cliente.getProspectoID()));
									sentenciaStore.setString("Par_EsMenorEdad",cliente.getEsMenorEdad());
									sentenciaStore.setInt("Par_ClienteTutorID",(cliente.getClienteTutorID() == Constantes.STRING_VACIO) ? Constantes.ENTERO_CERO : Utileria.convierteEntero(cliente.getClienteTutorID()));
									sentenciaStore.setString("Par_NombreTutor",cliente.getNombreTutor());
									sentenciaStore.setString("Par_ParentescoID", cliente.getParentescoID());
									sentenciaStore.setString("Par_ExtTelefonoPart",cliente.getExtTelefonoPart());
									sentenciaStore.setInt("Par_EjecutivoCap",Utileria.convierteEntero(cliente.getEjecutivoCap()));
									sentenciaStore.setInt("Par_PromotorExtInv",Utileria.convierteEntero(cliente.getPromotorExtInv()));


									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Salida",salidaPantalla);

									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Cliente",Types.INTEGER);


									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIOMENORALT "+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesDAO.altaCliente");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .SocioMenorDAO.altaSocioMenor");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Socio Menor" + e);
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


	//Modificacion Socio Menor
		public MensajeTransaccionBean modificaSocioMenor(final SocioMenorBean cliente) {
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
									cliente.setTelefonoCelular(cliente.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
									cliente.setTelefonoCasa(cliente.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
										String query = "call SOCIOMENORMOD(" +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?,?,?);";

										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cliente.getNumero()));
										sentenciaStore.setInt("Par_SucursalOri",Utileria.convierteEntero(cliente.getSucursalOrigen()));
										sentenciaStore.setString("Par_TipoPersona",cliente.getTipoPersona());
										sentenciaStore.setString("Par_Titulo",cliente.getTitulo());
										sentenciaStore.setString("Par_PrimerNom",cliente.getPrimerNombre());

										sentenciaStore.setString("Par_SegundoNom",cliente.getSegundoNombre());
										sentenciaStore.setString("Par_TercerNom",cliente.getTercerNombre());
										sentenciaStore.setString("Par_ApellidoPat",cliente.getApellidoPaterno());
										sentenciaStore.setString("Par_ApellidoMat",cliente.getApellidoMaterno());
										sentenciaStore.setString("Par_FechaNac",cliente.getFechaNacimiento());

										sentenciaStore.setInt("Par_LugarNac",Utileria.convierteEntero(cliente.getLugarNacimiento()));
										sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(cliente.getEstadoID()));
										sentenciaStore.setString("Par_Nacion",cliente.getNacion());
										sentenciaStore.setInt("Par_PaisResi",Utileria.convierteEntero(cliente.getPaisResidencia()));
										sentenciaStore.setString("Par_Sexo",cliente.getSexo());

										sentenciaStore.setString("Par_CURP",cliente.getCURP());
										sentenciaStore.setString("Par_RFC",Constantes.STRING_VACIO);
										sentenciaStore.setString("Par_EstadoCivil",cliente.getEstadoCivil());
										sentenciaStore.setString("Par_TelefonoCel",cliente.getTelefonoCelular());
										sentenciaStore.setString("Par_Telefono",cliente.getTelefonoCasa());

										sentenciaStore.setString("Par_Correo",cliente.getCorreo());
										sentenciaStore.setString("Par_RazonSocial",Constantes.STRING_VACIO);
										sentenciaStore.setInt("Par_TipoSocID",Constantes.ENTERO_CERO);
										sentenciaStore.setString("Par_RFCpm",Constantes.STRING_VACIO);
										sentenciaStore.setInt("Par_GrupoEmp",Constantes.ENTERO_CERO);

										sentenciaStore.setString("Par_Fax",Constantes.STRING_VACIO);
										sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(cliente.getOcupacionID()));
										sentenciaStore.setString("Par_Puesto",Constantes.STRING_VACIO);
										sentenciaStore.setString("Par_LugardeTrab",Constantes.STRING_VACIO);
										sentenciaStore.setFloat("Par_AntTra",Constantes.ENTERO_CERO);

										sentenciaStore.setString("Par_TelTrabajo",Constantes.STRING_VACIO);
										sentenciaStore.setString("Par_Clasific",cliente.getClasificacion());
										sentenciaStore.setString("Par_MotivoApert",cliente.getMotivoApertura());
										sentenciaStore.setString("Par_PagaISR",cliente.getPagaISR());
										sentenciaStore.setString("Par_PagaIVA",cliente.getPagaIVA());

										sentenciaStore.setString("Par_PagaIDE",cliente.getPagaIDE());
										sentenciaStore.setString("Par_NivelRiesgo",cliente.getNivelRiesgo());
										sentenciaStore.setInt("Par_SecGeneral",Utileria.convierteEntero(cliente.getSectorGeneral()));
										sentenciaStore.setString("Par_ActBancoMX",cliente.getActividadBancoMX());
										sentenciaStore.setInt("Par_ActINEGI",Utileria.convierteEntero(cliente.getActividadINEGI()));

										sentenciaStore.setString("Par_ActFR",cliente.getActividadFR());
										sentenciaStore.setInt("Par_ActFOMUR",Utileria.convierteEntero(cliente.getActividadFOMUR()));
										sentenciaStore.setInt("Par_SecEconomic",Utileria.convierteEntero(cliente.getSectorEconomico()));
										sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(cliente.getPromotorInicial()));
										sentenciaStore.setInt("Par_PromotorAct",Utileria.convierteEntero(cliente.getPromotorActual()));

										sentenciaStore.setString("Par_EsMenorEdad",cliente.getEsMenorEdad());
										sentenciaStore.setInt("Par_ClienteTutorID",(cliente.getClienteTutorID() == Constantes.STRING_VACIO) ? Constantes.ENTERO_CERO : Utileria.convierteEntero(cliente.getClienteTutorID()));
										sentenciaStore.setString("Par_NombreTutor",cliente.getNombreTutor());
										sentenciaStore.setString("Par_ExtTelefonoPart",cliente.getExtTelefonoPart());
										sentenciaStore.setString("Par_ParentescoID", cliente.getParentescoID());

										sentenciaStore.setInt("Par_EjecutivoCap",Utileria.convierteEntero(cliente.getEjecutivoCap()));
										sentenciaStore.setInt("Par_PromotorExtInv",Utileria.convierteEntero(cliente.getPromotorExtInv()));

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
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

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIOMENORMOD "+ sentenciaStore.toString());
										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SocioMenor.modSocio");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}

										return mensajeTransaccion;
									}
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .SocioMenorDAO.modSocioMenor");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de Socio Menor" + e);
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
	public SocioMenorBean consultaPrincipal(int tipoConsulta, SocioMenorBean socio) {
		SocioMenorBean socioBean = null;
		try{
			//Query con el Store Procedure
			String query = "call SOCIOMENORCON(?,?,?,?,?,"
											+ "?,?,?,?,?,?);";
			Object[] parametros = {	socio.getNumero(),
								"",
								"",
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIOMENORCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							SocioMenorBean cliente = new SocioMenorBean();
							cliente.setNumero(Utileria.completaCerosIzquierda(
	        						resultSet.getInt(1),SocioMenorBean.LONGITUD_ID));
							cliente.setSucursalOrigen(resultSet.getString(2));
							cliente.setTipoPersona(resultSet.getString(3));
							cliente.setTitulo(resultSet.getString(4));
							cliente.setPrimerNombre(resultSet.getString(5));
							cliente.setSegundoNombre(resultSet.getString(6));
							cliente.setTercerNombre(resultSet.getString(7));
							cliente.setApellidoPaterno(resultSet.getString(8));
							cliente.setApellidoMaterno(resultSet.getString(9));
							cliente.setFechaNacimiento(resultSet.getString(10));
							cliente.setLugarNacimiento(String.valueOf(resultSet.getInt(11)));
							cliente.setEstadoID(resultSet.getString(12));
							cliente.setNacion(resultSet.getString(13));
							cliente.setPaisResidencia(resultSet.getString(14));
							cliente.setSexo(resultSet.getString(15));
							cliente.setCURP(resultSet.getString(16));
							cliente.setRFC(resultSet.getString(17));
							cliente.setEstadoCivil(resultSet.getString(18));
							cliente.setTelefonoCelular(resultSet.getString(19));
							cliente.setTelefonoCasa(resultSet.getString(20));
							cliente.setCorreo(resultSet.getString(21));
							cliente.setRazonSocial(resultSet.getString(22));
							cliente.setTipoSociedadID(String.valueOf(resultSet.getInt(23)));
							cliente.setRFCpm(resultSet.getString(24));
							cliente.setGrupoEmpresarial(resultSet.getString(25));
							cliente.setFax(resultSet.getString(26));
							cliente.setOcupacionID(resultSet.getString(27));
							cliente.setPuesto(resultSet.getString(28));
							cliente.setLugarTrabajo(resultSet.getString(29));
							cliente.setAntiguedadTra(resultSet.getString(30));
							cliente.setTelTrabajo(resultSet.getString(31));
							cliente.setClasificacion(resultSet.getString(32));
							cliente.setMotivoApertura(resultSet.getString(33));
							cliente.setPagaISR(resultSet.getString(34));
							cliente.setPagaIVA(resultSet.getString(35));
							cliente.setPagaIDE(resultSet.getString(36));
							cliente.setNivelRiesgo(resultSet.getString(37));
							cliente.setSectorGeneral(resultSet.getString(38));
							cliente.setActividadBancoMX(resultSet.getString(39));
							cliente.setActividadINEGI(resultSet.getString(40));
							cliente.setSectorEconomico(resultSet.getString(41));
							cliente.setPromotorInicial(resultSet.getString(42));
							cliente.setPromotorActual(resultSet.getString(43));
							cliente.setNombreCompleto(resultSet.getString(44));
							cliente.setActividadFR(resultSet.getString(45));
							cliente.setActividadFOMUR(resultSet.getString(46));
							cliente.setEstatus(resultSet.getString(47));
							cliente.setTipoInactiva(resultSet.getString(48));
							cliente.setMotivoInactiva(resultSet.getString(49));
							cliente.setEsMenorEdad(resultSet.getString("EsMenorEdad"));//--
							cliente.setClienteTutorID(resultSet.getString(51));//50
							cliente.setNombreTutor(resultSet.getString(52));//51
							cliente.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
							cliente.setParentescoID(resultSet.getString("TipoRelacionID"));
							cliente.setEjecutivoCap(resultSet.getString("EjecutivoCap"));
							cliente.setPromotorExtInv(resultSet.getString("PromotorExtInv"));


						return cliente;
					}
		});
		socioBean= matches.size() > 0 ? (SocioMenorBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Socio Menor", e);

	}
	return socioBean;
	}

	/* Consuta Datos de tutor de socio menor*/
	public SocioMenorBean consultaDatosTutor(int clienteID,int tipoConsulta) {
		SocioMenorBean socioBean = null;
		try{
			String query = "call SOCIOMENORCON(?,?,?,?,?,"
											+ "?,?,?,?,?,?);";
			Object[] parametros = {	clienteID,
								"",
								"",
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.consultaTutor",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOCIOMENORCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							SocioMenorBean cliente = new SocioMenorBean();

							cliente.setNumero(Utileria.completaCerosIzquierda(resultSet.getInt(1),SocioMenorBean.LONGITUD_ID));
							cliente.setNombreTutor(resultSet.getString("NombreTutor"));
							cliente.setClienteTutorID(resultSet.getString("ClienteTutorID"));
							cliente.setParentescoTutor(resultSet.getString("ParentescoTutor"));

						return cliente;
					}
		});
		socioBean= matches.size() > 0 ? (SocioMenorBean) matches.get(0) : null;
	}catch(Exception e){

		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Socio Menor", e);

	}
	return socioBean;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}
