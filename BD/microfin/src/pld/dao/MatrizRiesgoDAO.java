package pld.dao;

import general.bean.MensajeTransaccionBean;
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

import pld.bean.MatrizRiesgoBean;

public class MatrizRiesgoDAO extends BaseDAO {


	public MatrizRiesgoDAO(){
		super();
	}

	public MensajeTransaccionBean actualizaValoresRiesgo(final MatrizRiesgoBean matrizRiesgoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(
				parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try{
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(
									parametrosAuditoriaBean.getOrigenDatos())).execute(
											new CallableStatementCreator() {
												public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
													String query = "call CATMATRIZRIESGOACT(?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?);";
													CallableStatement sentenciaStore = arg0.prepareCall(query);

													/*se reemplazan las comas por cadena vacia, sino en caso de venir por ejemplo 9,000 lo convierte a 0*/
													sentenciaStore.setInt("Par_PEPNacional",Utileria.convierteEntero(matrizRiesgoBean.getPepNacional().replace(",","")));
													sentenciaStore.setInt("Par_PEPExtranejero",	Utileria.convierteEntero(matrizRiesgoBean.getPepExtranjero().replace(",","")));
													sentenciaStore.setInt("Par_Localidad",	Utileria.convierteEntero(matrizRiesgoBean.getLocalidad().replace(",","")));
													sentenciaStore.setInt("Par_ActEconomica",Utileria.convierteEntero(matrizRiesgoBean.getActEconomica().replace(",","")));
													sentenciaStore.setInt("Par_OrigenRecursos",Utileria.convierteEntero(matrizRiesgoBean.getOrigenRecursos().replace(",","")));

													sentenciaStore.setInt("Par_ProdCredito",Utileria.convierteEntero(matrizRiesgoBean.getProdCredito().replace(",","")));
													sentenciaStore.setInt("Par_DestCredito",Utileria.convierteEntero(matrizRiesgoBean.getDestCredito().replace(",","")));
													sentenciaStore.setInt("Par_LiAlertInusualesMesVal",Utileria.convierteEntero(matrizRiesgoBean.getLiAlertInusualesMesVal().replace(",","")));
													sentenciaStore.setInt("Par_LiAlertInusualesMesLimite", Utileria.convierteEntero(matrizRiesgoBean.getLiAlertInusualesMesLimite().replace(",","")));
													sentenciaStore.setInt("Par_LiOperRelevMesVal",Utileria.convierteEntero(matrizRiesgoBean.getLiOperRelevMesVal().replace(",","")));

													sentenciaStore.setInt("Par_LiOperRelevMesLimite",Utileria.convierteEntero(matrizRiesgoBean.getLiOperRelevMesLimite().replace(",","")));
													sentenciaStore.setInt("Par_PaisNacimiento",Utileria.convierteEntero(matrizRiesgoBean.getPaisNacimiento().replace(",","")));
													sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(matrizRiesgoBean.getPaisResidencia().replace(",","")));
													sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
													sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

													sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
													sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
													sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
													sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
													sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

													sentenciaStore.setString("Aud_ProgramaID", "MatrizRiesgoDAO.ActualizaValoresRiesgo" );
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
														mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
														mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
														mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
													}else{
														mensajeTransaccion.setNumero(999);
														mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
													}
													return mensajeTransaccion;
												}
											});
							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}catch(Exception e){
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de matriz de riesgo pld", e);
						}
						return mensajeBean;
					}
				});
		return mensaje;
	}
	/**
	 * Realiza la ejecución del SP de Evaluación del Nivel de Riesgo de los Clientes
	 * de acuerdo a la Matriz de Riesgo y Niveles de Riesgo Vigentes.
	 * @param matrizRiesgoBean : Clase bean con la fecha de ejecución.
	 * @return {@link MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean evaluacion(final MatrizRiesgoBean matrizRiesgoBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(
							parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call ACTRIESGOCTEPRO(?,?,?,?,?,	"
																		+ "?,?,?,?,?,	"
																		+ "?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TipoCliente",Utileria.convierteEntero(matrizRiesgoBean.getTipoCliente()));
									sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch(Exception e){
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la evaluación de matriz de riesgo pld: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List listaPrincipal(int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CATMATRIZRIESGOCON(?,?,?,?,?,	?,?,?);";
		Object[] parametros = {	tipoConsulta,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"MatrizRiesgoDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATMATRIZRIESGOCON(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MatrizRiesgoBean conceptoRiesgo = new MatrizRiesgoBean();
				conceptoRiesgo.setConceptoMatrizID(resultSet.getString("ConceptoMatrizID"));
				conceptoRiesgo.setConcepto(resultSet.getString("Concepto"));
				conceptoRiesgo.setDescripcion(resultSet.getString("Descripcion"));
				conceptoRiesgo.setValor(resultSet.getString("Valor"));
				conceptoRiesgo.setLimiteValida(resultSet.getString("LimiteValida"));
				return conceptoRiesgo;
			}
		});

		return matches;
	}
}
