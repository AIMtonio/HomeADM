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
import aportaciones.bean.TasasAportacionesBean;

public class TasasAportacionesDAO extends BaseDAO {

	private final static String salidaPantalla = "S";

	// INICIO DE MÉTODOS PARA DAR DE ALTA LAS TASAS
	/* metodo que manda llamar los metodo para dar de alta tasa de Aportaciones*/
	public MensajeTransaccionBean procesarAlta(final TasasAportacionesBean bean, final List listaSucursales) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TasasAportacionesBean beanV;
					TasasAportacionesBean beanD;
					if(listaSucursales!=null){
						if(listaSucursales.size()>0){
							bean.setBandera("S");
						}else{
							bean.setBandera("N");
						}

						for(int i=0; i<listaSucursales.size(); i++){
							/* obtenemos un bean de la lista */
							beanV = (TasasAportacionesBean)listaSucursales.get(i);
							bean.setTasaID("0");
							bean.setTipoProdID(Integer.toString(bean.getTipoAportacionID()));
							bean.setTipoInstrumentoID("28");
							mensajeBean = validaciones(bean,beanV,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

						mensajeBean = altaTasas(bean,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						bean.setTasaAportacionID(mensajeBean.getConsecutivoString());
						String TasaID=bean.getTasaAportacionID();
						if(listaSucursales!=null){
							for(int i=0; i<listaSucursales.size(); i++){
								/* obtenemos un bean de la lista */
								beanD = (TasasAportacionesBean)listaSucursales.get(i);
								mensajeBean = altaSucursales(bean,beanD,parametrosAuditoriaBean.getNumeroTransaccion());
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						mensajeBean.setConsecutivoString(TasaID);
						mensajeBean.setDescripcion("Tasa de Aportaciones Agregada Exitosamente: "+mensajeBean.getConsecutivoString());

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Tasas de Aportaciones.", e);
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

	}// fin de procesar alta

	/*Validaciones de tasas*/
	public MensajeTransaccionBean validaciones(final TasasAportacionesBean bean, final  TasasAportacionesBean beanD, final long Numtransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call VALIDATASASAPORTACIONES(?,?,?,?,?, ?,?,?,?,?,  ?,?,?,   ?,?,?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_TasaID", Utileria.convierteEntero(bean.getTasaID()));
					sentenciaStore.setInt("Par_TipoProdID", Utileria.convierteEntero(bean.getTipoProdID()));
					sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(bean.getMontoInferior()));
					sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(bean.getMontoSuperior()));
					sentenciaStore.setInt("Par_PlazoInferior",bean.getPlazoInferior());

					sentenciaStore.setInt("Par_PlazoSuperior",bean.getPlazoSuperior());
					sentenciaStore.setString("Par_Calificacion",bean.getCalificacion());
					sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(beanD.getSucursalID()));
					sentenciaStore.setInt("Par_TipoInstrumento",Utileria.convierteEntero(bean.getTipoInstrumentoID()));
					sentenciaStore.setString("Par_TipoPersona", bean.getTipoPersona());

					sentenciaStore.setString("Par_Salida",salidaPantalla);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Falló. El Procedimiento no Regresó Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Validaciones de Tasas de Aportaciones", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin

	/*Metodo para dar de alta tasa de APORTACIONES*/
	public MensajeTransaccionBean altaTasas(final TasasAportacionesBean bean, final long Numtransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TASASAPORTACIONESALT(?,?,?,?,?,  	?,?,?,?,?, " +
										  						   "?,?,?,  	?,?,?," +
										  						   "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoAportacionID",bean.getTipoAportacionID());
								sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(bean.getMontoInferior()));
								sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(bean.getMontoSuperior()));
								sentenciaStore.setInt("Par_PlazoInferior",bean.getPlazoInferior());
								sentenciaStore.setInt("Par_PlazoSuperior",bean.getPlazoSuperior());

								sentenciaStore.setString("Par_Calificacion",bean.getCalificacion());
								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(bean.getTasaFija()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(bean.getTasaBase()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(bean.getSobreTasa()));
								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(bean.getPisoTasa()));

								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(bean.getTechoTasa()));
								sentenciaStore.setInt("Par_CalculoInteres",Utileria.convierteEntero(bean.getCalculoInteres()));
								sentenciaStore.setString("Par_Validacion",bean.getBandera());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);

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
									mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Falló. El Procedimiento no Regresó Ningún Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Tasas de Aportaciones", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}//fin alta tasas


	/* da de alta una sucursal referente a la tasa*/
	public MensajeTransaccionBean altaSucursales(final TasasAportacionesBean bean, final  TasasAportacionesBean beanD, final long Numtransaccion) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call TASAAPORTACIONSUCURSALESALT(?,?,?,?,?, ?,?,?,  ?,?,?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_TasaAportacionID", Utileria.convierteEntero(bean.getTasaAportacionID()));
					sentenciaStore.setInt("Par_TipoAportacionID", beanD.getTipoAportacionID());
					sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(beanD.getSucursalID()));
					sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(beanD.getEstadoID()));
					sentenciaStore.setString("Par_Estatus",beanD.getEstatus());

					sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
					sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
					sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
					sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
					sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
					sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
					sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASAAPORTACIONSUCURSALESALT(" + sentenciaStore.toString() + ")");
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
								mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Falló. El Procedimiento no Regresó Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tipos de aportaciones por sucursal", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta de Sucursales
	// FIN DE MÉTODOS PARA DAR DE ALTA LAS TASAS


	// INICIO DE MÉTODOS PARA MODIFICAR LAS TASAS
	/* metodo que manda llamar los metodos para la modificacion de Tasas por Aportaciones*/
	public MensajeTransaccionBean procesarModificacion(final TasasAportacionesBean bean, final List listaSucursales , final String tasa) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TasasAportacionesBean beanV;
					TasasAportacionesBean beanD;
					if(listaSucursales!=null){
						if(listaSucursales.size()>0){
							bean.setBandera("S");
						}else{
							bean.setBandera("N");
						}

						for(int i=0; i<listaSucursales.size(); i++){
							/* obtenemos un bean de la lista */
							beanV = (TasasAportacionesBean)listaSucursales.get(i);
							bean.setTasaID(tasa);
							bean.setTipoProdID(Integer.toString(bean.getTipoAportacionID()));
							bean.setTipoInstrumentoID("28");
							mensajeBean = validaciones(bean,beanV,parametrosAuditoriaBean.getNumeroTransaccion());
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}

						mensajeBean = modificaTasas(bean,parametrosAuditoriaBean.getNumeroTransaccion());
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
						bean.setTasaAportacionID(mensajeBean.getConsecutivoString());
						String TasaID=bean.getTasaAportacionID();
						if(listaSucursales!=null){
							for(int i=0; i<listaSucursales.size(); i++){
								/* obtenemos un bean de la lista */
								beanD = (TasasAportacionesBean)listaSucursales.get(i);
								if(beanD.getEstatus().equalsIgnoreCase("A")){
									mensajeBean = altaSucursales(bean,beanD,parametrosAuditoriaBean.getNumeroTransaccion());
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}

							}
						}
						mensajeBean.setConsecutivoString(TasaID);
						mensajeBean.setDescripcion("Tasa de Aportaciones Modificada Exitosamente: "+tasa);
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Tasas de Aportaciones.", e);
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

	}// fin de procesar modifica

	/*Metodo para Modificar tasa de APORTACIONES*/
	public MensajeTransaccionBean modificaTasas(final TasasAportacionesBean bean,final long Numtransaccion) {
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
								String query = "call TASASAPORTACIONESMOD(?,?,?,?,?,?,?,?,?,?, " +
										  						   "?,?,?,?,?,?,?,?,?,?, " +
										  						   "?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TasaAportacionID",Utileria.convierteEntero(bean.getTasaAportacionID()));
								sentenciaStore.setInt("Par_TipoAportacionID",bean.getTipoAportacionID());
								sentenciaStore.setDouble("Par_MontoInferior",Utileria.convierteDoble(bean.getMontoInferior()));
								sentenciaStore.setDouble("Par_MontoSuperior",Utileria.convierteDoble(bean.getMontoSuperior()));
								sentenciaStore.setInt("Par_PlazoInferior",bean.getPlazoInferior());

								sentenciaStore.setInt("Par_PlazoSuperior",bean.getPlazoSuperior());
								sentenciaStore.setString("Par_Calificacion",bean.getCalificacion());
								sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(bean.getTasaFija()));
								sentenciaStore.setInt("Par_TasaBase",Utileria.convierteEntero(bean.getTasaBase()));
								sentenciaStore.setDouble("Par_SobreTasa",Utileria.convierteDoble(bean.getSobreTasa()));

								sentenciaStore.setDouble("Par_PisoTasa",Utileria.convierteDoble(bean.getPisoTasa()));
								sentenciaStore.setDouble("Par_TechoTasa",Utileria.convierteDoble(bean.getTechoTasa()));
								sentenciaStore.setInt("Par_CalculoInteres",Utileria.convierteEntero(bean.getCalculoInteres()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Numtransaccion);

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
									mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Falló. El Procedimiento no Regresó Ningún Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Tasas de Aportaciones", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	// FIN DE MÉTODOS PARA MODIFICAR LAS TASAS

	// INICIO DE MÉTODOS PARA ELIMINAR LAS TASAS
	/*Metodo Para eliminar tasa de APORTACIONES*/
	public MensajeTransaccionBean eliminaTasas(final TasasAportacionesBean bean, final int numBaja) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TASASAPORTACIONESBAJ(?,?,?, ?,?,?,  ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_TasaAportacionID", Utileria.convierteEntero(bean.getTasaAportacionID()));
							sentenciaStore.setInt("Par_TipoAportacionID", bean.getTipoAportacionID());
							sentenciaStore.setInt("Par_NumBaj",numBaja);

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

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESBAJ(" + sentenciaStore.toString() + ")");

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
								mensajeTransaccion.setDescripcion("Falló. El Procedimiento no Regresó Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Falló. El Procedimiento no Regresó Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de Tasas de aportaciones.", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin
	// FIN DE MÉTODOS PARA ELIMINAR LAS TASAS

	// INICIO DE MÉTODOS PARA CONSULTAR LAS TASAS
	// aportaciones consulta principal
	public TasasAportacionesBean consultaPrincipal(TasasAportacionesBean tasasAportacionesBean, int tipoConsulta){
		String query = "call TASASAPORTACIONESCON(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = { tasasAportacionesBean.getTipoAportacionID(),
								tasasAportacionesBean.getTasaAportacionID(),
								tasasAportacionesBean.getMontoInferior(),
								tasasAportacionesBean.getMontoSuperior(),
								tasasAportacionesBean.getPlazoInferior(),
								tasasAportacionesBean.getPlazoSuperior(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TasasAportacionesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAportacionesBean tasasAportacionesBean = new TasasAportacionesBean();
				tasasAportacionesBean.setTasaAportacionID(resultSet.getString(1));
				tasasAportacionesBean.setTipoAportacionID(Utileria.convierteEntero(resultSet.getString(2)));
				tasasAportacionesBean.setMontoID(resultSet.getString(3));
				tasasAportacionesBean.setPlazoID(resultSet.getString(4));
				tasasAportacionesBean.setCalificacion(resultSet.getString(5));
				tasasAportacionesBean.setTasaFija(resultSet.getString(6));
				tasasAportacionesBean.setTasaBase(resultSet.getString(7));
				tasasAportacionesBean.setSobreTasa(resultSet.getString(8));
				tasasAportacionesBean.setPisoTasa(resultSet.getString(9));
				tasasAportacionesBean.setTechoTasa(resultSet.getString(10));
				tasasAportacionesBean.setCalculoInteres(resultSet.getString(11));
				return tasasAportacionesBean;
			}
		});
		return matches.size() > 0 ? (TasasAportacionesBean) matches.get(0) : null;
	}

	// aportaciones consulta tasa variable
	public TasasAportacionesBean consultaTasaVariable(TasasAportacionesBean tasasAportacionesBean, int tipoConsulta){
		String query = "call TASASAPORTACIONESCON(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = { tasasAportacionesBean.getTipoAportacionID(),
								Constantes.ENTERO_CERO,
								tasasAportacionesBean.getMonto(),
								Constantes.DOUBLE_VACIO,
								tasasAportacionesBean.getPlazo(),
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TasasAportacionesDAO.consultaTasaVariable",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TasasAportacionesBean tasasAportacionesBean = new TasasAportacionesBean();
				tasasAportacionesBean.setTipoAportacionID(Utileria.convierteEntero(resultSet.getString("TasaBase")));
				tasasAportacionesBean.setCalculoInteres(resultSet.getString("CalculoInteres"));
				tasasAportacionesBean.setNombreTasaBase(resultSet.getString("NombreTasaBase"));

				return tasasAportacionesBean;
			}
		});
		return matches.size() > 0 ? (TasasAportacionesBean) matches.get(0) : null;
	}

	// aportaciones consulta tasa
	public TasasAportacionesBean consultaTasa(TasasAportacionesBean tasasAportacionesBean){
		String query = "call TASASAPORTACIONESCAL(?,?,?,?,?);";


		Object[] parametros = {
				tasasAportacionesBean.getTipoAportacionID(),
				tasasAportacionesBean.getPlazo(),
				tasasAportacionesBean.getMonto(),
				tasasAportacionesBean.getCalificacion(),
				tasasAportacionesBean.getSucursalID()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESCAL(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAportacionesBean tasasAportacionesBean = new TasasAportacionesBean();
				tasasAportacionesBean.setTasaAnualizada(resultSet.getString("TasaAnualizada"));
				tasasAportacionesBean.setTasaBase(resultSet.getString("Var_TasaBase"));
				tasasAportacionesBean.setCalculoInteres(resultSet.getString("Var_CalculoInteres"));
				tasasAportacionesBean.setSobreTasa(resultSet.getString(4));
				tasasAportacionesBean.setPisoTasa(resultSet.getString(5));
				tasasAportacionesBean.setTechoTasa(resultSet.getString(6));
				tasasAportacionesBean.setValorGat(resultSet.getString(7));
				tasasAportacionesBean.setValorGatReal(resultSet.getString(8));
				return tasasAportacionesBean;
			}
		});
		return matches.size() > 0 ? (TasasAportacionesBean)  matches.get(0) : null;
	}
	// FIN DE MÉTODOS PARA CONSULTAR LAS TASAS

	// INICIO DE MÉTODOS PARA LISTAS DE TASAS
	/*Lista principal de tasas*/
	public List listaPrincipal(TasasAportacionesBean tasasAportacionesBean, int tipoLista){
		String query = "call TASASAPORTACIONESLIS(?,?,?,? ,?,?,? ,?,?,?);";
		Object[] parametros = {
				tasasAportacionesBean.getTipoAportacionID(),
				tipoLista,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasAportacionesDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAportacionesBean tasasAportacionesBean = new TasasAportacionesBean();
				tasasAportacionesBean.setTasaAportacionID(resultSet.getString(1));
				tasasAportacionesBean.setMontoID(resultSet.getString(2));
				tasasAportacionesBean.setPlazoID(resultSet.getString(3));
				tasasAportacionesBean.setCalificacion(resultSet.getString(4));
				return tasasAportacionesBean;
			}
		});
		return matches;
	}

	/*Lista reportes de tasas*/
	public List listaReporte(TasasAportacionesBean tasasAportacionesBean, int tipoLista){
		String query = "call TASASAPORTACIONESLIS(?,?,?,? ,?,?,? ,?,?,?);";
		Object[] parametros = {
				tasasAportacionesBean.getTipoAportacionID(),
				tipoLista,
				tasasAportacionesBean.getPlazoID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasAportacionesDAO.listaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAportacionesBean tasasAportacionesBean = new TasasAportacionesBean();
				tasasAportacionesBean.setTasaAportacionID(resultSet.getString("TasaAportacionID"));
				tasasAportacionesBean.setPlazoID(resultSet.getString("Plazos"));
				tasasAportacionesBean.setMontosConTasa(resultSet.getString("MontosConTasa"));
				tasasAportacionesBean.setTasaFija(resultSet.getString("TasaFija"));
				return tasasAportacionesBean;
			}
		});
		return matches;
	}

	/*Lista Grid de tasas*/
	public List listaGrid(TasasAportacionesBean tasasAportacionesBean, int tipoLista){
		String query = "call TASASAPORTACIONESLIS(?,?,?,? ,?,?,? ,?,?,?);";
		Object[] parametros = {
				tasasAportacionesBean.getTipoAportacionID(),
				tipoLista,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TasasAportacionesDAO.listaGrid",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASAPORTACIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasasAportacionesBean tasasAportacionesBean = new TasasAportacionesBean();
				tasasAportacionesBean.setTasaAportacionID(resultSet.getString(1));
				tasasAportacionesBean.setPlazoID(resultSet.getString(2));
				tasasAportacionesBean.setMontoID(resultSet.getString(3));
				tasasAportacionesBean.setTasaFija(resultSet.getString(4));
				tasasAportacionesBean.setTasaBase(resultSet.getString(5));
				tasasAportacionesBean.setSobreTasa(resultSet.getString(6));
				tasasAportacionesBean.setPisoTasa(resultSet.getString(7));
				tasasAportacionesBean.setTechoTasa(resultSet.getString(8));
				tasasAportacionesBean.setCalificacion(resultSet.getString(9));
				return tasasAportacionesBean;
			}
		});
		return matches;
	}
	// FIN DE MÉTODOS PARA LISTAS DE TASAS
}
