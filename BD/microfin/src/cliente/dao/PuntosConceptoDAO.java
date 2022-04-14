
package cliente.dao;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import cliente.bean.PuntosConceptoBean;

public class PuntosConceptoDAO extends BaseDAO {

	public PuntosConceptoDAO(){
		super();
	}


	/*=============================== METODOS ==================================*/


	/* metodo que procesa el alta de un registro de puntos por concepto*/
	public MensajeTransaccionBean procesaModificar(final PuntosConceptoBean puntosConceptoBean, final List listaPuntosConcepto) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					 PuntosConceptoBean bean;
					 String Eliminar_SI = "S";
					 String Eliminar_NO = "N";

					if(listaPuntosConcepto!=null){
						if(listaPuntosConcepto.size() > 0){
							for(int i=0; i<listaPuntosConcepto.size(); i++){
								/* obtenemos un bean de la lista */
								bean = (PuntosConceptoBean)listaPuntosConcepto.get(i);
								if(i==0){
									mensajeBean = modificar(bean, puntosConceptoBean.getConceptoCalifID(), Eliminar_SI);
								}
								else if(i > 0) {
									mensajeBean = modificar(bean, puntosConceptoBean.getConceptoCalifID(), Eliminar_NO);
								}

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
						else if(listaPuntosConcepto.size() == 0){
							mensajeBean = modificar(puntosConceptoBean, puntosConceptoBean.getConceptoCalifID(), Eliminar_SI);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar modificación de puntos concepto", e);
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin de procesarAlta


	/* Modificacion de todas las clasificaciones de cliente*/
	public MensajeTransaccionBean modificar(final PuntosConceptoBean puntosConceptoBean, final String conceptoCalifID, final String eliminar) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					/* Query con el Store Procedure */
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PUNTOSCONCEPTOPRO(" +
															"?,?,?,?,?,  ?,?,?,?,?," +
															"?,?,?,?,?,  ?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_PuntosConcepID", Utileria.convierteEntero(puntosConceptoBean.getPuntosConcepID()));
								sentenciaStore.setInt("Par_ConceptoCalifID", Utileria.convierteEntero(conceptoCalifID));
								sentenciaStore.setDouble("Par_RangoInferior", Utileria.convierteDoble(puntosConceptoBean.getRangoInferior()));
								sentenciaStore.setDouble("Par_RangoSuperior", Utileria.convierteDoble(puntosConceptoBean.getRangoSuperior()));
								sentenciaStore.setDouble("Par_Puntos", Utileria.convierteDoble(puntosConceptoBean.getPuntos()));

								sentenciaStore.setString("Par_Elimina",eliminar);
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUNTOSCONCEPTOPRO(" + sentenciaStore.toString() + ")");

								return sentenciaStore;

							} //public sql exception

						} // new CallableStatementCreator
						,new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
								}
								return mensajeTransaccion;
							}// public

						}// CallableStatementCallback
						);


					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}


				} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error modificación de puntos concepto", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});

			return mensaje;
		}// fin de alta


	/* Lista para mostrar en grid*/
	public List listaPrincipal(int tipoLista, PuntosConceptoBean puntosConceptoBean) {
		String query = "call PUNTOSCONCEPTOLIS(?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(puntosConceptoBean.getConceptoCalifID()),
								tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PUNTOSCONCEPTOLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PuntosConceptoBean rangos = new PuntosConceptoBean();

				rangos.setPuntosConcepID(resultSet.getString("PuntosConcepID"));
				rangos.setRangoInferior(resultSet.getString("RangoInferior"));
				rangos.setRangoSuperior(resultSet.getString("RangoSuperior"));
				rangos.setPuntos(resultSet.getString("Puntos"));

				return rangos;
			}
		});

		return matches;
	}	// fin de lista


}
