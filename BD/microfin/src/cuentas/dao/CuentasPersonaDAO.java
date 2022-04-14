package cuentas.dao;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cuentas.bean.CuentasAhoBean;
import cuentas.bean.CuentasPersonaBean;

public class CuentasPersonaDAO extends BaseDAO {

	ParametrosSesionBean parametrosSesionBean;

	public CuentasPersonaDAO() {
		super();
	}

	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean alta(final CuentasPersonaBean cuentasPersona) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

				cuentasPersona.setTelefonoCasa(cuentasPersona.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
				cuentasPersona.setTelefonoCelular(cuentasPersona.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));//
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CUENTASPERSONAALT(?,?,?,?,?,		?,?,?,?,?,"+
										  							  "?,?,?,?,?,		?,?,?,?,?,"+
										  							  "?,?,?,?,?,		?,?,?,?,?,"+
										  							  "?,?,?,?,?,		?,?,?,?,?,"+
										  							  "?,?,?,?,?,		?,?,?,?,?,"+
										  							  "?,?,?,?,?,		?,?,?,?,?,"+
										  							  "?,?,?,?,?,		?,?,?,?,?,?," +
										  							  "?,?,?,?,?,		?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasPersona.getCuentaAhoID()));
								sentenciaStore.setString("Par_EsApoderado",cuentasPersona.getEsApoderado());
								sentenciaStore.setString("Par_EsTitular",cuentasPersona.getEsTitular());
								sentenciaStore.setString("Par_EsCotitular",cuentasPersona.getEsCotitular());
								sentenciaStore.setString("Par_EsBeneficiario",cuentasPersona.getEsBeneficiario());

								sentenciaStore.setString("Par_EsProvRecurso",cuentasPersona.getEsProvRecurso());
								sentenciaStore.setString("Par_EsPropReal",cuentasPersona.getEsPropReal());
								sentenciaStore.setString("Par_EsFirmante",cuentasPersona.getEsFirmante());

								sentenciaStore.setString("Par_Titulo",cuentasPersona.getTitulo()	);
								sentenciaStore.setString("Par_PrimerNom",cuentasPersona.getPrimerNombre());

								sentenciaStore.setString("Par_SegundoNom",cuentasPersona.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",cuentasPersona.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat", cuentasPersona.getApellidoPaterno() );
								sentenciaStore.setString("Par_ApellidoMat", cuentasPersona.getApellidoMaterno());
								sentenciaStore.setDate("Par_FechaNac",herramientas.OperacionesFechas.conversionStrDate(cuentasPersona.getFechaNacimiento()));

								sentenciaStore.setInt("Par_PaisNac", Utileria.convierteEntero(cuentasPersona.getPaisNacimiento()));
								sentenciaStore.setInt("Par_EdoNac", Utileria.convierteEntero(cuentasPersona.getEdoNacimiento()));
								sentenciaStore.setString("Par_EdoCivil", cuentasPersona.getEstadoCivil()	);
								sentenciaStore.setString("Par_Sexo",cuentasPersona.getSexo()	);
								sentenciaStore.setString("Par_Nacion",cuentasPersona.getNacion() );

								sentenciaStore.setString("Par_CURP",cuentasPersona.getCURP() );
								sentenciaStore.setString("Par_RFC",cuentasPersona.getRFC());
								sentenciaStore.setInt("Par_OcupacionID",  Utileria.convierteEntero(cuentasPersona.getOcupacionID()));
								sentenciaStore.setString("Par_FEA",cuentasPersona.getFEA());
								sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(cuentasPersona.getPaisFea()));
								sentenciaStore.setInt("Par_PaisRFC", Utileria.convierteEntero(cuentasPersona.getPaisRFC()));

								sentenciaStore.setString("Par_PuestoA", cuentasPersona.getPuestoA() 	);
								sentenciaStore.setInt("Par_SectorGral",Utileria.convierteEntero(cuentasPersona.getSectorGeneral()));
								sentenciaStore.setString("Par_ActBancoMX", cuentasPersona.getActividadBancoMX());
								sentenciaStore.setInt("Par_ActINEGI", Utileria.convierteEntero(cuentasPersona.getActividadINEGI()	) );
								sentenciaStore.setInt("Par_SecEcono", Utileria.convierteEntero(cuentasPersona.getSectorEconomico()	 ));

								sentenciaStore.setInt("Par_TipoIdentiID",	Utileria.convierteEntero(cuentasPersona.getTipoIdentiID()) );
								sentenciaStore.setString("Par_OtraIden",cuentasPersona.getOtraIdentifi());
								sentenciaStore.setString("Par_NumIden",	cuentasPersona.getNumIdentific());
								sentenciaStore.setString("Par_FecExIden",Utileria.convierteFecha(cuentasPersona.getFecExIden()));
								sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(cuentasPersona.getFecVenIden()));

								sentenciaStore.setString("Par_Domicilio", cuentasPersona.getDomicilio());
								sentenciaStore.setString("Par_TelCasa", cuentasPersona.getTelefonoCasa());
								sentenciaStore.setString("Par_TelCel",cuentasPersona.getTelefonoCelular());
								sentenciaStore.setString("Par_Correo",cuentasPersona.getCorreo());
								sentenciaStore.setInt("Par_PaisRes",Utileria.convierteEntero(cuentasPersona.getPaisResidencia())); // No estaba

								sentenciaStore.setString("Par_DocEstLegal",cuentasPersona.getDocEstanciaLegal());
								sentenciaStore.setString("Par_DocExisLegal",cuentasPersona.getDocExisLegal());
								sentenciaStore.setString("Par_FechaVenEst",Utileria.convierteFecha(cuentasPersona.getFechaVenEst()));
								sentenciaStore.setString("Par_NumEscPub",cuentasPersona.getNumEscPub());
								sentenciaStore.setString("Par_FechaEscPub", Utileria.convierteFecha(cuentasPersona.getFechaEscPub()));

								sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(cuentasPersona.getEstadoID())	);
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(cuentasPersona.getMunicipioID()));
								sentenciaStore.setInt("Par_NotariaID",Utileria.convierteEntero(cuentasPersona.getNotariaID()));
								sentenciaStore.setString("Par_TitularNotaria",cuentasPersona.getTitularNotaria() );
								sentenciaStore.setString("Par_RazonSocial",	cuentasPersona.getRazonSocial() );

								sentenciaStore.setString("Par_Fax",	cuentasPersona.getFax()  );
								sentenciaStore.setInt("Par_ParentescoID",Utileria.convierteEntero(cuentasPersona.getParentescoID()));
								sentenciaStore.setDouble("Par_Porcentaje",	Utileria.convierteDoble(cuentasPersona.getPorcentaje())  );
								sentenciaStore.setInt("Par_ClienteID",	Utileria.convierteEntero(cuentasPersona.getClienteID())  );
								sentenciaStore.setString("Par_ExtTelefonoPart",cuentasPersona.getExtTelefonoPart());
								sentenciaStore.setDouble("Par_IngreRealoRecur", Utileria.convierteDoble(cuentasPersona.getIngreRealoRecursos()));

								//parametros para Personas morales
								sentenciaStore.setString("Par_CorreoPM",cuentasPersona.getCorreoPM());
								sentenciaStore.setString("Par_TelefonoPM",cuentasPersona.getTelefonoPM());
								sentenciaStore.setString("Par_ExtTelefonoPM",cuentasPersona.getExtTelefonoPM());
								sentenciaStore.setString("Par_DomicilioOfiPM",cuentasPersona.getDomicilioOfiPM());
								sentenciaStore.setString("Par_RazonSocialPM",	cuentasPersona.getRazonSocialPM() );

								sentenciaStore.setString("Par_FechaRegistroPM",Utileria.convierteFecha(cuentasPersona.getFechaRegistroPM()));
								sentenciaStore.setInt("Par_PaisConstitucion",Utileria.convierteEntero(cuentasPersona.getPaisConstitucionID()));
								sentenciaStore.setString("Par_RFCpm",cuentasPersona.getRFCpm());
								sentenciaStore.setString("Par_EsAccionista",cuentasPersona.getEsAccionista());
								sentenciaStore.setDouble("Par_PorcentajeAcc",	Utileria.convierteDoble(cuentasPersona.getPorcentajeAccionista()));
								sentenciaStore.setString("Par_FeaPM",cuentasPersona.getFeaPM());
								sentenciaStore.setInt("Par_PaisFeaPM",Utileria.convierteEntero(cuentasPersona.getPaisFeaPM()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Relacionado a la Cuenta: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de cuentas de personal: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final CuentasPersonaBean cuentasPersona) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					cuentasPersona.setTelefonoCasa(cuentasPersona.getTelefonoCasa().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
					cuentasPersona.setTelefonoCelular(cuentasPersona.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(							new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CUENTASPERSONAMOD(	?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?,	?,?,?,?,?," +
																		"?,?,?,?,?, ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(cuentasPersona.getCuentaAhoID()));
								sentenciaStore.setInt("Par_PersonaID",Utileria.convierteEntero(cuentasPersona.getPersonaID()));
								sentenciaStore.setString("Par_EsApoderado",cuentasPersona.getEsApoderado());
								sentenciaStore.setString("Par_EsTitular",cuentasPersona.getEsTitular());
								sentenciaStore.setString("Par_EsCotitular",cuentasPersona.getEsCotitular());

								sentenciaStore.setString("Par_EsBeneficiario",cuentasPersona.getEsBeneficiario());
								sentenciaStore.setString("Par_EsProvRecurso",cuentasPersona.getEsProvRecurso());
								sentenciaStore.setString("Par_EsPropReal",cuentasPersona.getEsPropReal());
								sentenciaStore.setString("Par_EsFirmante",cuentasPersona.getEsFirmante());
								sentenciaStore.setString("Par_Titulo",cuentasPersona.getTitulo()	);

								sentenciaStore.setString("Par_PrimerNom",cuentasPersona.getPrimerNombre());
								sentenciaStore.setString("Par_SegundoNom",cuentasPersona.getSegundoNombre());
								sentenciaStore.setString("Par_TercerNom",cuentasPersona.getTercerNombre());
								sentenciaStore.setString("Par_ApellidoPat", cuentasPersona.getApellidoPaterno() );
								sentenciaStore.setString("Par_ApellidoMat", cuentasPersona.getApellidoMaterno());

								sentenciaStore.setString("Par_FechaNac",Utileria.convierteFecha(cuentasPersona.getFechaNacimiento()));
								sentenciaStore.setInt("Par_PaisNac", Utileria.convierteEntero(cuentasPersona.getPaisNacimiento()));
								sentenciaStore.setInt("Par_EdoNac", Utileria.convierteEntero(cuentasPersona.getEdoNacimiento()));
								sentenciaStore.setString("Par_EdoCivil", cuentasPersona.getEstadoCivil()	);
								sentenciaStore.setString("Par_Sexo",cuentasPersona.getSexo()	);

								sentenciaStore.setString("Par_Nacion",cuentasPersona.getNacion() );
								sentenciaStore.setString("Par_CURP",cuentasPersona.getCURP() );
								sentenciaStore.setString("Par_RFC",cuentasPersona.getRFC());
								sentenciaStore.setInt("Par_OcupacionID",  Utileria.convierteEntero(cuentasPersona.getOcupacionID()));
								sentenciaStore.setString("Par_FEA",cuentasPersona.getFEA());
								sentenciaStore.setInt("Par_PaisFEA",Utileria.convierteEntero(cuentasPersona.getPaisFea()));

								sentenciaStore.setInt("Par_PaisRFC",  Utileria.convierteEntero(cuentasPersona.getPaisRFC()));
								sentenciaStore.setString("Par_PuestoA", cuentasPersona.getPuestoA() 	);
								sentenciaStore.setInt("Par_SectorGral",Utileria.convierteEntero(cuentasPersona.getSectorGeneral()));
								sentenciaStore.setString("Par_ActBancoMX", cuentasPersona.getActividadBancoMX());
								sentenciaStore.setInt("Par_ActINEGI", Utileria.convierteEntero(cuentasPersona.getActividadINEGI()	) );

								sentenciaStore.setInt("Par_SecEcono", Utileria.convierteEntero(cuentasPersona.getSectorEconomico()	 ));
								sentenciaStore.setInt("Par_TipoIdentiID",	Utileria.convierteEntero(cuentasPersona.getTipoIdentiID()) );
								sentenciaStore.setString("Par_OtraIden",cuentasPersona.getOtraIdentifi());
								sentenciaStore.setString("Par_NumIden",	cuentasPersona.getNumIdentific());
								sentenciaStore.setString("Par_FecExIden",Utileria.convierteFecha(cuentasPersona.getFecExIden()));

								sentenciaStore.setString("Par_FecVenIden",Utileria.convierteFecha(cuentasPersona.getFecVenIden()));
								sentenciaStore.setString("Par_Domicilio", cuentasPersona.getDomicilio());
								sentenciaStore.setString("Par_TelCasa", cuentasPersona.getTelefonoCasa());
								sentenciaStore.setString("Par_TelCel",cuentasPersona.getTelefonoCelular());
								sentenciaStore.setString("Par_Correo",cuentasPersona.getCorreo());

								sentenciaStore.setInt("Par_PaisRes",Utileria.convierteEntero(cuentasPersona.getPaisResidencia())); // No estaba
								sentenciaStore.setString("Par_DocEstLegal",cuentasPersona.getDocEstanciaLegal());
								sentenciaStore.setString("Par_DocExisLegal",cuentasPersona.getDocExisLegal());
								sentenciaStore.setString("Par_FechaVenEst",Utileria.convierteFecha(cuentasPersona.getFechaVenEst()));
								sentenciaStore.setString("Par_NumEscPub",cuentasPersona.getNumEscPub());

								sentenciaStore.setString("Par_FechaEscPub", Utileria.convierteFecha(cuentasPersona.getFechaEscPub()));
								sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(cuentasPersona.getEstadoID())	);
								sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(cuentasPersona.getMunicipioID()));
								sentenciaStore.setInt("Par_NotariaID",Utileria.convierteEntero(cuentasPersona.getNotariaID()));
								sentenciaStore.setString("Par_TitularNotaria",cuentasPersona.getTitularNotaria() );

								sentenciaStore.setString("Par_RazonSocial",	cuentasPersona.getRazonSocial() );
								sentenciaStore.setString("Par_Fax",	cuentasPersona.getFax()  );
								sentenciaStore.setInt("Par_ParentescoID",Utileria.convierteEntero(cuentasPersona.getParentescoID()));
								sentenciaStore.setDouble("Par_Porcentaje",	Utileria.convierteDoble(cuentasPersona.getPorcentaje())  );
								sentenciaStore.setInt("Par_ClienteID",	Utileria.convierteEntero(cuentasPersona.getClienteID())  );

								sentenciaStore.setString("Par_ExtTelefonoPart", cuentasPersona.getExtTelefonoPart());
								sentenciaStore.setDouble("Par_IngreRealoRecur",Utileria.convierteDoble(cuentasPersona.getIngreRealoRecursos()));

								//parametros para Personas morales
								sentenciaStore.setString("Par_CorreoPM",cuentasPersona.getCorreoPM());
								sentenciaStore.setString("Par_TelefonoPM",cuentasPersona.getTelefonoPM());
								sentenciaStore.setString("Par_ExtTelefonoPM",cuentasPersona.getExtTelefonoPM());
								sentenciaStore.setString("Par_DomicilioOfiPM",cuentasPersona.getDomicilioOfiPM());
								sentenciaStore.setString("Par_RazonSocialPM",	cuentasPersona.getRazonSocialPM() );

								sentenciaStore.setString("Par_FechaRegistroPM",Utileria.convierteFecha(cuentasPersona.getFechaRegistroPM()));
								sentenciaStore.setInt("Par_PaisConstitucion",Utileria.convierteEntero(cuentasPersona.getPaisConstitucionID()));
								sentenciaStore.setString("Par_RFCpm",cuentasPersona.getRFCpm());
								sentenciaStore.setString("Par_EsAccionista",cuentasPersona.getEsAccionista());
								sentenciaStore.setDouble("Par_PorcentajeAcc",	Utileria.convierteDoble(cuentasPersona.getPorcentajeAccionista()));
								sentenciaStore.setString("Par_FeaPM",cuentasPersona.getFeaPM());
								sentenciaStore.setInt("Par_PaisFeaPM",Utileria.convierteEntero(cuentasPersona.getPaisFeaPM()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion del Relacionado a la Cuenta: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de cuentas de personal: ", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
// Método para eliminar una persona relacionada solo cambiará el estatus tony

	public MensajeTransaccionBean elimina(final CuentasPersonaBean cuentasPersona) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CUENTASPERSONABAJ(?,?,?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasPersona.getCuentaAhoID()));
								sentenciaStore.setString("Par_PersonaID", cuentasPersona.getPersonaID());

								sentenciaStore.setString("Par_Salida",salidaPantalla);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Error en la Baja de la Persona Relacionada.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Eliminación de Personas Relacionadas", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public CuentasPersonaBean consultaPrincipal(CuentasPersonaBean cuentasPersona, int tipoConsulta){
		CuentasPersonaBean cuentasPersonaBean=null;
		try{
			String query = "call CUENTASPERSONACON(?,?,?,? ,?,?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteLong(cuentasPersona.getCuentaAhoID()),
						Integer.parseInt(cuentasPersona.getPersonaID()),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentasPersonaDAO.consultaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONACON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();

					cuentasPersona.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1), CuentasAhoBean.LONGITUD_ID));
					cuentasPersona.setPersonaID(Utileria.completaCerosIzquierda(resultSet.getInt(2), 4));
					cuentasPersona.setEsApoderado(resultSet.getString(3));
					cuentasPersona.setEsTitular(resultSet.getString(4));
					cuentasPersona.setEsCotitular(resultSet.getString(5));

					cuentasPersona.setEsBeneficiario(resultSet.getString(6));
					cuentasPersona.setEsProvRecurso(resultSet.getString(7));
					cuentasPersona.setEsPropReal(resultSet.getString(8));
					cuentasPersona.setEsFirmante(resultSet.getString(9));
					cuentasPersona.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getInt(10), 4));

					cuentasPersona.setTitulo(resultSet.getString(11));
					cuentasPersona.setPrimerNombre(resultSet.getString(12));
					cuentasPersona.setSegundoNombre(resultSet.getString(13));
					cuentasPersona.setTercerNombre(resultSet.getString(14));
					cuentasPersona.setApellidoPaterno(resultSet.getString(15));

					cuentasPersona.setApellidoMaterno(resultSet.getString(16));
					cuentasPersona.setNombreCompleto(resultSet.getString(17));
					cuentasPersona.setFechaNacimiento(resultSet.getString(18));
					cuentasPersona.setPaisNacimiento(resultSet.getString(19));
					cuentasPersona.setEstadoCivil(resultSet.getString(20));

					cuentasPersona.setSexo(resultSet.getString(21));
					cuentasPersona.setNacion(resultSet.getString(22));
					cuentasPersona.setCURP(resultSet.getString(23));
					cuentasPersona.setRFC(resultSet.getString(24));
					cuentasPersona.setOcupacionID(resultSet.getString(25));

					cuentasPersona.setFEA(resultSet.getString(26));
					cuentasPersona.setPaisFea(resultSet.getString(27));
					cuentasPersona.setPaisRFC(resultSet.getString(28));
					cuentasPersona.setPuestoA(resultSet.getString(29));
					cuentasPersona.setSectorGeneral(resultSet.getString(30));
					cuentasPersona.setActividadBancoMX(resultSet.getString(31));

					cuentasPersona.setActividadINEGI(resultSet.getString(32));
					cuentasPersona.setSectorEconomico(resultSet.getString(33));
					cuentasPersona.setTipoIdentiID(resultSet.getString(34));
					cuentasPersona.setOtraIdentifi(resultSet.getString(35));
					cuentasPersona.setNumIdentific(resultSet.getString(36));

					cuentasPersona.setFecExIden(resultSet.getString(37));
					cuentasPersona.setFecVenIden(resultSet.getString(38));
					cuentasPersona.setDomicilio(resultSet.getString(39));
					cuentasPersona.setTelefonoCasa(resultSet.getString(40));
					cuentasPersona.setTelefonoCelular(resultSet.getString(41));

					cuentasPersona.setCorreo(resultSet.getString(42));
					cuentasPersona.setPaisResidencia(resultSet.getString(43));
					cuentasPersona.setDocEstanciaLegal(resultSet.getString(44));
					cuentasPersona.setDocExisLegal(resultSet.getString(45));
					cuentasPersona.setFechaVenEst(resultSet.getString(46));

					cuentasPersona.setNumEscPub(resultSet.getString(47));
					cuentasPersona.setFechaEscPub(resultSet.getString(48));
					cuentasPersona.setEdoNacimiento(resultSet.getString("EdoNacimiento"));
					cuentasPersona.setExtTelefonoPart(resultSet.getString("ExtTelefonoPart"));
					cuentasPersona.setIngreRealoRecursos(resultSet.getString("IngresoRealoRecur"));

					cuentasPersona.setEsAccionista(resultSet.getString("EsAccionista"));
					cuentasPersona.setPorcentajeAccionista(resultSet.getString("PorcentajeAcciones"));
					cuentasPersona.setRazonSocialPM(resultSet.getString("RazonSocial"));

					if(resultSet.getInt(48) == Constantes.ENTERO_CERO){
						cuentasPersona.setEstadoID(Constantes.STRING_VACIO);
					}else{
						cuentasPersona.setEstadoID(Utileria.completaCerosIzquierda(resultSet.getInt(49), 5));
					}


					if(resultSet.getInt(49) == Constantes.ENTERO_CERO){
						cuentasPersona.setMunicipioID(Constantes.STRING_VACIO);
					}else{
						cuentasPersona.setMunicipioID(Utileria.completaCerosIzquierda(resultSet.getInt(50), 6));
					}


					if(resultSet.getInt(50) == Constantes.ENTERO_CERO){
						cuentasPersona.setNotariaID(Constantes.STRING_VACIO);
					}else{
						cuentasPersona.setNotariaID(Utileria.completaCerosIzquierda(resultSet.getInt(51), 6));
					}
					cuentasPersona.setTitularNotaria(resultSet.getString(52));
					cuentasPersona.setRazonSocial(resultSet.getString(53));
					cuentasPersona.setFax(resultSet.getString(54));
					cuentasPersona.setParentescoID(Utileria.completaCerosIzquierda(resultSet.getInt(55), 4));
					cuentasPersona.setPorcentaje(resultSet.getString(56));
					cuentasPersona.setClienteID(resultSet.getString("ClienteID"));
					return cuentasPersona;
				}
			});cuentasPersonaBean=matches.size() > 0 ? (CuentasPersonaBean) matches.get(0) : null;
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la consulta de Personas Relacionadas");
				}
		return cuentasPersonaBean;
	}

	public CuentasPersonaBean consultaFirmante(CuentasPersonaBean cuentasPersona, int tipoConsulta){
		String query = "call CUENTASPERSONACON(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteLong(cuentasPersona.getCuentaAhoID()),
					Utileria.convierteEntero(cuentasPersona.getPersonaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasPersonaDAO.consultaFirmante",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1), CuentasAhoBean.LONGITUD_ID));
				cuentasPersona.setPersonaID(Utileria.completaCerosIzquierda(resultSet.getInt(2), 4));
				cuentasPersona.setNombreCompleto(resultSet.getString(3));
				return cuentasPersona;
			}
		});
		return matches.size() > 0 ? (CuentasPersonaBean) matches.get(0) : null;

	}

	// usada para saber si existe una persona relacionada a la cuenta
	public CuentasPersonaBean consultaExiste (CuentasPersonaBean cuentasPersona, int tipoConsulta){
		CuentasPersonaBean cuentasPersonaBean = null;
		try{
			String query = "call CUENTASPERSONACON(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
						Utileria.convierteLong(cuentasPersona.getCuentaAhoID()),
						Constantes.ENTERO_CERO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"CuentasPersonaDAO.consultaExiste",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
					cuentasPersona.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1), CuentasAhoBean.LONGITUD_ID));
					cuentasPersona.setPersonaID(Utileria.completaCerosIzquierda(resultSet.getInt(2), 4));
					cuentasPersona.setNombreCompleto(resultSet.getString(3));
					return cuentasPersona;
				}
			});
			cuentasPersonaBean =  matches.size() > 0 ? (CuentasPersonaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta para ver si existen pesona relacionada ala cuenta", e);
		}
		return cuentasPersonaBean;
	}

	public List listaPrincipal(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					cuentasPersona.getNombreCompleto(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setPersonaID(String.valueOf(resultSet.getInt(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));

				return cuentasPersona;

			}
		});
		return matches;
	}

	public List listaFirmante(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					"",
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaFirmante",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setPersonaID(String.valueOf(resultSet.getInt(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));
				cuentasPersona.setEsFirmante(resultSet.getString(3)); // para mostar el tipo de CUENTASFIRMA
				cuentasPersona.setTercerNombre(resultSet.getString(4));// para mostar la instruccion especial

				return cuentasPersona;

			}
		});
		return matches;
	}

	/*Lista para Apoderados que se muestran en el Reporte*/
	public List listaApoderados(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					"",
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaApoderados",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));
				cuentasPersona.setTipoIdentiID(resultSet.getString(3));
				cuentasPersona.setPuestoA(resultSet.getString(4));

				return cuentasPersona;

			}
		});
		return matches;
	}

	//Lista de firmantes que se muestran en el reporte conocimiento de cuenta persona fisica
	public List listaFirmantes2(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					"",
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaFirmantes2",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));
				cuentasPersona.setEsFirmante(resultSet.getString(3));
				cuentasPersona.setTipoIdentiID(resultSet.getString(4));

				return cuentasPersona;

			}
		});
		return matches;
	}
	//Lista de cotitulares que se muestran en el reporte conocimiento de cuenta persona fisica
	public List listaCotitulares(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					"",
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaCotitulares",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));
				cuentasPersona.setEsFirmante(resultSet.getString(3));
				cuentasPersona.setTipoIdentiID(resultSet.getString(4));

				return cuentasPersona;

			}
		});
		return matches;
	}

	//Lista de beneficiarios que se muestran en la portada del contrato de persona fisica
	public List listaBeneficiarios(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					"",
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaBeneficiarios",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));
				cuentasPersona.setPorcentaje(resultSet.getString(3));
				cuentasPersona.setDescripParentesco(resultSet.getString(4));

				return cuentasPersona;

			}
		});
		return matches;
	}

	//Lista de Apoderados que se muestran en el anexo de la portada del contrato de persona fisica
	public List listaAnexoPortadaContrato(CuentasPersonaBean cuentasPersona, int tipoLista){
		String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
					cuentasPersona.getCuentaAhoID(),
					"",
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasPersonaDAO.listaAnexoPortadaContrato",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
				cuentasPersona.setCuentaAhoID(String.valueOf(resultSet.getString(1)));
				cuentasPersona.setNombreCompleto(resultSet.getString(2));
				cuentasPersona.setRFC(resultSet.getString(3));
				cuentasPersona.setFechaNacimiento(resultSet.getString(4));
				cuentasPersona.setDomicilio(resultSet.getString(5));

				return cuentasPersona;

			}
		});
		return matches;
	}

	//Lista de de relacionados cuenta para pantalla consulta de personas requerimiento seido
		public List listaRelacionadosCta(CuentasPersonaBean cuentasPersona, int tipoLista){
			String query = "call CUENTASPERSONALIS(?,?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
						Constantes.ENTERO_CERO,
						cuentasPersona.getNombreCompleto(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"CuentasPersonaDAO.listaPersonasReqSeido",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASPERSONALIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasPersonaBean cuentasPersona = new CuentasPersonaBean();
					cuentasPersona.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaAhoID")));
					cuentasPersona.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					cuentasPersona.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cuentasPersona.setFechaNacimiento(resultSet.getString("FechaNac"));
					cuentasPersona.setCURP(resultSet.getString("CURP"));
					cuentasPersona.setRFC(resultSet.getString("RFC"));
					cuentasPersona.setPaisNacimiento(resultSet.getString("NombrePais"));
					cuentasPersona.setDesOcupacion(resultSet.getString("Ocupacion"));
					cuentasPersona.setTipoPersona(resultSet.getString("TipoPersona"));
					return cuentasPersona;

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