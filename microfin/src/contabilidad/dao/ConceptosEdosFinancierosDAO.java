package contabilidad.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.ConceptosEdosFinancierosBean;

public class ConceptosEdosFinancierosDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public ConceptosEdosFinancierosDAO() {
		super();
	}


	/**
	 * Método que regista las conseptos para los reportes financieros para el monitoreo de la cartera agro (FIRA).
	 * @param conceptosEdosFinBean : Clase bean con los paraámetros de entrada al SP-CONCEEDOSFINFIRAALT.
	 * @param numTransaccion : Número de Transacción.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final ConceptosEdosFinancierosBean conceptosEdosFinBean, final Long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONCEEDOSFINFIRAALT("
											+ "?,?,?,?,?,	?,?,?,?,?,	"
											+ "?,?,?,?,?,	?,?,?,?,?,	"
											+ "?,?,?,?,?,	?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_EstadoFinanID",Utileria.convierteEntero(conceptosEdosFinBean.getEstadoFinanID()));
									sentenciaStore.setInt("Par_ConceptoFinanID", Utileria.convierteEntero(conceptosEdosFinBean.getConceptoFinanID()));
									sentenciaStore.setInt("Par_NumClien",Utileria.convierteEntero(conceptosEdosFinBean.getNumClien()));
									sentenciaStore.setString("Par_Descripcion", conceptosEdosFinBean.getDescripcion());
									sentenciaStore.setString("Par_Desplegado",conceptosEdosFinBean.getDesplegado());

									sentenciaStore.setString("Par_CuentaContable",conceptosEdosFinBean.getCuentaContable());
									sentenciaStore.setString("Par_EsCalculado",conceptosEdosFinBean.getEsCalculado());
									sentenciaStore.setString("Par_TipoCalculo",conceptosEdosFinBean.getTipoCalculo());
									sentenciaStore.setString("Par_NombreCampo",conceptosEdosFinBean.getNombreCampo());
									sentenciaStore.setInt("Par_Espacios",Utileria.convierteEntero(conceptosEdosFinBean.getEspacios()));

									sentenciaStore.setString("Par_Negrita",conceptosEdosFinBean.getNegrita());
									sentenciaStore.setString("Par_Sombreado", conceptosEdosFinBean.getSombreado());
									sentenciaStore.setInt("Par_CombinarCeldas",Utileria.convierteEntero(conceptosEdosFinBean.getCombinarCeldas()));
									sentenciaStore.setString("Par_CuentaFija", conceptosEdosFinBean.getCuentaFija());
									sentenciaStore.setString("Par_Presentacion",conceptosEdosFinBean.getPresentacion());

									sentenciaStore.setString("Par_Tipo",conceptosEdosFinBean.getTipo());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConceptosEdosFinDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConceptosEdosFinDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de los Conceptos Financieros: " + e);
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
	/**
	 * Elimina los conceptos que fueron registados antes de la nueva generación de los reportes.
	 * @param conceptosEdosFinBean : Clase bean con los paraámetros de entrada al SP-CONCEEDOSFINFIRABAJ.
	 * @param numTransaccion : Número de Transacción.
	 * @return {@linkplain MensajeTransaccionBean} con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean baja(final ConceptosEdosFinancierosBean conceptosEdosFinBean, final Long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONCEEDOSFINFIRABAJ("
											+ "?,?,?,?,?,	?,?,?,?,?,	"
											+ "?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_EstadoFinanID",Utileria.convierteEntero(conceptosEdosFinBean.getEstadoFinanID()));
									sentenciaStore.setInt("Par_NumClien",Utileria.convierteEntero(conceptosEdosFinBean.getNumClien()));
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma())
									;
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ConceptosEdosFinDAO.baja");
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
						throw new Exception(Constantes.MSG_ERROR + " .ConceptosEdosFinDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de los Conceptos Financieros: " + e);
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
	/**
	 * Lista los conceptos de los estados financieros que no son para la Cartera Agro (FIRA).
	 * @param conceptosEdosFinBean : Clase bean con los parámetros de entrada al SP-CONCEPESTADOSFINLIS.
	 * @param tipoLista : Número de Lista.
	 * @return Lista de objetos {@linkplain ConceptosEdosFinancierosBean}.
	 * @author avelasco
	 */
	public ArrayList<ConceptosEdosFinancierosBean> lista(ConceptosEdosFinancierosBean conceptosEdosFinBean, int tipoLista){
		String query = "call CONCEPESTADOSFINLIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?,?,	"
				+ "?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(conceptosEdosFinBean.getEstadoFinanID()),
				Utileria.convierteEntero(conceptosEdosFinBean.getConceptoFinanID()),
				Utileria.convierteEntero(conceptosEdosFinBean.getNumClien()),
				conceptosEdosFinBean.getEsCalculado(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptosEdosFinDAO.lista",

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPESTADOSFINLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				ConceptosEdosFinancierosBean conceptosEdosFinBean = new ConceptosEdosFinancierosBean();
				conceptosEdosFinBean.setEstadoFinanID(resultSet.getString("EstadoFinanID"));
				conceptosEdosFinBean.setConceptoFinanID(resultSet.getString("ConceptoFinanID"));
				conceptosEdosFinBean.setNumClien(resultSet.getString("NumClien"));
				conceptosEdosFinBean.setDescripcion(resultSet.getString("Descripcion"));
				conceptosEdosFinBean.setDesplegado(resultSet.getString("Desplegado"));
				conceptosEdosFinBean.setCuentaContable(resultSet.getString("CuentaContable"));
				conceptosEdosFinBean.setEsCalculado(resultSet.getString("EsCalculado"));
				conceptosEdosFinBean.setNombreCampo(resultSet.getString("NombreCampo"));
				conceptosEdosFinBean.setEspacios(resultSet.getString("Espacios"));
				conceptosEdosFinBean.setNegrita(resultSet.getString("Negrita"));
				conceptosEdosFinBean.setSombreado(resultSet.getString("Sombreado"));
				conceptosEdosFinBean.setCombinarCeldas(resultSet.getString("CombinarCeldas"));
				conceptosEdosFinBean.setCuentaFija(resultSet.getString("CuentaFija"));
				conceptosEdosFinBean.setPresentacion(resultSet.getString("Presentacion"));
				conceptosEdosFinBean.setTipo(resultSet.getString("Tipo"));

				return conceptosEdosFinBean;
			}
		});
		return (ArrayList<ConceptosEdosFinancierosBean>)matches;
	}
}