package aportaciones.dao;

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


import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import aportaciones.bean.MontosAportacionesBean;
import aportaciones.dao.TasasAportacionesDAO;

public class MontosAportacionesDAO extends BaseDAO{

	private TasasAportacionesDAO tasasAportacionesDAO;

	public MontosAportacionesDAO() {
		super();
	}

	/*graba lista de Alta de Montos*/
	public MensajeTransaccionBean grabaListaMontosAportaciones(final MontosAportacionesBean montos,final List listaMontosAportaciones) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				MontosAportacionesBean montoBean;

				aportaciones.bean.TasasAportacionesBean tasaAportaciones = new aportaciones.bean.TasasAportacionesBean();
				tasaAportaciones.setTasaAportacionID("0");
				tasaAportaciones.setTipoAportacionID(montos.getTipoAportacionID());

				mensajeBean = bajaMontosAportaciones(montos);

				if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
				for(int i=0; i<listaMontosAportaciones.size(); i++){
					montoBean = (MontosAportacionesBean)listaMontosAportaciones.get(i);
					mensajeBean = altaMontos(montoBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(0);
				mensajeBean.setDescripcion("Informacion Actualizada. No Olvide Actualizar las Tasas de Aportaciones.");
				mensajeBean.setNombreControl("tipoAportacionID");
			} catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en grabacion de listas de monto de aportaciones", e);
				}
				return mensajeBean;
			}
		});
			return mensaje;
	}

	// alta de montos de aportaciones
	public MensajeTransaccionBean altaMontos(final MontosAportacionesBean montoAportaciones) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MONTOSAPORTACIONESALT(?,?,?, ?,?,?,  ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoAportacionID",montoAportaciones.getTipoAportacionID());
								sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(montoAportaciones.getMontoInferior()));
								sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(montoAportaciones.getMontoSuperior()));


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Rango de Montos de aportaciones.", e);
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

	// consulta principal de montos
	public MontosAportacionesBean consultaPrincipal(MontosAportacionesBean montosAportacionesBean, int tipoConsulta){
		String query = "call MONTOSAPORTACIONESCON(?,?,?,?,?,  ?,?,?,?,?,  ?);";
		Object[] parametros = { montosAportacionesBean.getTipoAportacionID(),
								montosAportacionesBean.getMontoInferior(),
								montosAportacionesBean.getMontoSuperior(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MontosAportacionesDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOSAPORTACIONESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				MontosAportacionesBean montosAportacionesBean = new MontosAportacionesBean();

					montosAportacionesBean.setTipoAportacionID(Utileria.convierteEntero(resultSet.getString(1)));
					montosAportacionesBean.setMontoInferior(resultSet.getString(2));
					montosAportacionesBean.setMontoSuperior(resultSet.getString(3));

				return montosAportacionesBean;
			}
		});
		return matches.size() > 0 ? (MontosAportacionesBean) matches.get(0) : null;
	}


	// Método para dar de baja los montos de aportaciones.
	public MensajeTransaccionBean bajaMontosAportaciones(final MontosAportacionesBean montoAportacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MONTOSAPORTACIONESBAJ(?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoAportacionID",montoAportacion.getTipoAportacionID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
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
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Rango de Montos de aportaciones.", e);
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

	/* Lista para grid de montos*/
	public List lista(MontosAportacionesBean bean, int tipoLista) {
		String query = "call MONTOSAPORTACIONESLIS(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	bean.getTipoAportacionID(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"MontosAportacionesDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOSAPORTACIONESLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MontosAportacionesBean beanResultado = new MontosAportacionesBean();
				beanResultado.setMontoInferior(resultSet.getString("MontoInferior"));
				beanResultado.setMontoSuperior(resultSet.getString("MontoSuperior"));
				return beanResultado;
			}
		});

		return matches;
	}

	public List listaComboBox(MontosAportacionesBean bean, int tipoLista) {
		String query = "call MONTOSAPORTACIONESLIS(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	bean.getTipoAportacionID(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"MontosAportacionesDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONTOSAPORTACIONESLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MontosAportacionesBean beanResultado = new MontosAportacionesBean();
				beanResultado.setMontosDescripcion(resultSet.getString(1));
				return beanResultado;
			}
		});

		return matches;
	}

	public TasasAportacionesDAO getTasasAportacionesDAO() {
		return tasasAportacionesDAO;
	}

	public void setTasasAportacionesDAO(TasasAportacionesDAO tasasAportacionesDAO) {
		this.tasasAportacionesDAO = tasasAportacionesDAO;
	}



}
