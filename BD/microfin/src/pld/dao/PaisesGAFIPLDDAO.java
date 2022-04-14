package pld.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
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

import pld.bean.PLDListasPersBloqBean;
import pld.bean.PaisesGAFIPLDBean;

public class PaisesGAFIPLDDAO extends BaseDAO {

	java.sql.Date fecha = null;

	public PaisesGAFIPLDDAO(){
		super();
	}

	private final static String salidaPantalla = "S";

	/**
	 * Método de alta de paises al catálogo de la GAFI.
	 * @param paisesBean : Clase bean que contiene los valores de los parámetros de entrada al SP-CATPAISESGAFIALT.
	 * @param NumeroTransaccion : Número de transacción, para que se envié sólo un número por todas las altas.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final PaisesGAFIPLDBean paisesBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATPAISESGAFIALT(?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_PaisID", paisesBean.getPaisID());
									sentenciaStore.setString("Par_NombrePais", paisesBean.getNombre());
									sentenciaStore.setString("Par_TipoPais", paisesBean.getTipoPais());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PaisesGAFIPLDDAO.alta");
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
						throw new Exception(Constantes.MSG_ERROR + " .PaisesGAFIPLDDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Paises GAFI PLD: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de alta en el histórico de paises catálogo de la GAFI.
	 * @param paisesBean : Clase bean que contiene los valores de los parámetros de entrada al SP-HISCATPAISESGAFIALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean altaHistorico(final PaisesGAFIPLDBean paisesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISCATPAISESGAFIALT(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoPais", paisesBean.getTipoPais());
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PaisesGAFIPLDDAO.altaHistorico");
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
						throw new Exception(Constantes.MSG_ERROR + " .PaisesGAFIPLDDAO.altaHistorico");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico Paises GAFI PLD: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que lista los paises, los paises cooperantes y los en mejora.
	 * @param paisesBean : Clase bean para los valores de los parámetros de entrada al SP-CATPAISESGAFILIS. Uso futuro.
	 * @param tipoLista : Tipo de Lista. 1.- Paises en Mejora 2.- Paises No Cooperantes.
	 * @return List : Lista de clases bean PaisesGAFIPLDBean.
	 * @author avelasco
	 */
	public List<PaisesGAFIPLDBean> lista(PaisesGAFIPLDBean paisesBean, int tipoLista) {
		List<PaisesGAFIPLDBean> lista=new ArrayList<PaisesGAFIPLDBean>();
		String query = "CALL CATPAISESGAFILIS(?,?,?,?,?,   " +
											 "?,?,?);";
		Object[] parametros = {
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"PaisesGAFIPLDDAO.lista",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call CATPAISESGAFILIS(" + Arrays.toString(parametros) + ");");
		try{
			List<PaisesGAFIPLDBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PaisesGAFIPLDBean parametro = new PaisesGAFIPLDBean();
					parametro.setPaisID(resultSet.getString("PaisID"));
					parametro.setNombre((resultSet.getString("Nombre")));
					parametro.setTipoPais(resultSet.getString("TipoPais"));
					return parametro;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en PaisesGAFIPLDDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método que dependiendo del tipo de catálogo, elimina y registra los nuevos paises en el catálogo.
	 * @param paisesBean : Clase bean que contiene los valores para dar de baja del catálogo y da de alta en el histórico.
	 * @param listaDetalle : Lista de los nuevos paises a registrar.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean grabaDetalle(final PaisesGAFIPLDBean paisesBean,final List<PaisesGAFIPLDBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean=altaHistorico(paisesBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(PaisesGAFIPLDBean detalle : listaDetalle){
						mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar detalle: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * Método que realiza la consulta del Pais en el cátalogo de la GAFI y si lo encuentra lo registra como coincidencia
	 * @param paisesBean: Bean con los datos para realizar
	 * @return
	 */
	public PaisesGAFIPLDBean consultaDeteccion(final PaisesGAFIPLDBean paisesBean) {
		try {
			transaccionDAO.generaNumeroTransaccion();
			String query = "call PLDDETECGAFICON("
					+ "?,?,?,?,?,    "
					+ "?,?,?,?,?,    "
					+ "?,?,?,?,?,    "
					+ "?,?);";
			Object[] parametros = {
					paisesBean.getClavePersonaInv(),
					paisesBean.getPaisID(),
					paisesBean.getPrimerNombre(),
					paisesBean.getSegundoNombre(),
					paisesBean.getTercerNombre(),

					paisesBean.getApellidoPaterno(),
					paisesBean.getApellidoMaterno(),
					paisesBean.getTipoPersona(),
					paisesBean.getRazonSocial(),
					paisesBean.getTipoPersSAFI(),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PaisesGAFIPLDDAO.consultaDeteccion",

					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDDETECGAFICON(" + Arrays.toString(parametros) + ");");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PaisesGAFIPLDBean pais = new PaisesGAFIPLDBean();
					pais.setEstaEnCatalogo(resultSet.getString("EstaEnCatalogo"));
					pais.setTipoPais(resultSet.getString("TipoPais"));
					pais.setNombre(resultSet.getString("Nombre"));
					return pais;
				}
			});
			return matches.size() > 0 ? (PaisesGAFIPLDBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;

	}

}