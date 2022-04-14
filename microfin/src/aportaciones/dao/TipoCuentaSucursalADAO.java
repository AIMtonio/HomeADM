package aportaciones.dao;

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
import aportaciones.bean.TipoCuentaSucursalABean;

public class TipoCuentaSucursalADAO extends BaseDAO{

	public TipoCuentaSucursalADAO() {
		super();
	}

	/* metodo para que manda llamar el metodo alta en el cual se llama al sp y se inserta el registro*/
	public MensajeTransaccionBean procesarAlta(final List listaSucursales) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					TipoCuentaSucursalABean bean;

					if(listaSucursales!=null){
						for(int i=0; i<listaSucursales.size(); i++){
							/* obtenemos un bean de la lista */
							bean = (TipoCuentaSucursalABean)listaSucursales.get(i);

							/*Si es el primero eliminara todos los registros de la tabla para insertar todos de nuevo */
							if(i==0){
								mensajeBean = alta(bean,"S");
							}
							else{
								mensajeBean = alta(bean,"N");
							}

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de tipos de cuenta por sucursal", e);
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


	/* da de alta una sucursal */
	public MensajeTransaccionBean alta(final TipoCuentaSucursalABean bean, final String esPrimero) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call TIPOAPORTSUCURSALESALT(?,?,?,?,?, ?,  ?,?,?,  ?,?,?,?,?,?,?);";

				CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setInt("Par_InstrumentoID", Utileria.convierteEntero(bean.getInstrumentoID()));
					sentenciaStore.setInt("Par_TipoInstrumentoID", Utileria.convierteEntero(bean.getTipoInstrumentoID()));
					sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(bean.getSucursalID()));
					sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(bean.getEstadoID()));
					sentenciaStore.setString("Par_Estatus",bean.getEstatus());

					sentenciaStore.setString("Par_EsPrimero",esPrimero);

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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOAPORTSUCURSALESALT(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tipos de cuentas por sucursal", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin de alta

	/* Lista de sucursales en las cuales estara disponible el producto de ahorro*/
	public List lista(TipoCuentaSucursalABean bean, int tipoLista) {
		String query = "call TIPOAPORTSUCURSALESLIS(?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(bean.getInstrumentoID()),
								Utileria.convierteEntero(bean.getTipoInstrumentoID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TipoCuentaSucursalDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOAPORTSUCURSALESLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoCuentaSucursalABean beanResultado = new TipoCuentaSucursalABean();

				beanResultado.setSucursalID(resultSet.getString("SucursalID"));
				beanResultado.setEstadoID(resultSet.getString("EstadoID"));
				beanResultado.setNombreSucursal(resultSet.getString("NombreSucursal"));
				beanResultado.setNombreEstado(resultSet.getString("NombreEstado"));
				beanResultado.setEstatus(resultSet.getString("Estatus"));

				return beanResultado;
			}
		});

		return matches;
	}

	/* Lista de sucursales filtrando segun lo que este en pantalla*/
	public List listaFiltro(TipoCuentaSucursalABean bean, int tipoLista) {
		String query = "call TIPOAPORTSUCURSALESLIS(?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(bean.getInstrumentoID()),
								Utileria.convierteEntero(bean.getTipoInstrumentoID()),
								Utileria.convierteEntero(bean.getSucursalID()),
								Utileria.convierteEntero(bean.getEstadoID()),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TipoCuentaSucursalDAO.listaFiltro",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOAPORTSUCURSALESLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoCuentaSucursalABean beanResultado = new TipoCuentaSucursalABean();

				beanResultado.setSucursalID(resultSet.getString("SucursalID"));
				beanResultado.setEstadoID(resultSet.getString("EstadoID"));
				beanResultado.setNombreSucursal(resultSet.getString("NombreSucursal"));
				beanResultado.setNombreEstado(resultSet.getString("NombreEstado"));
				beanResultado.setEstatus(resultSet.getString("Estatus"));

				return beanResultado;
			}
		});

		return matches;
	}

	/* da de baja todas las sucursales de un tipo de cuenta */
	public MensajeTransaccionBean baja(final TipoCuentaSucursalABean bean) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TIPOAPORTSUCURSALESBAJ(?,?,?,?,?, ?,?,?,?,?,  ?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_InstrumentoID", Utileria.convierteEntero(bean.getInstrumentoID()));
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


							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOAPORTSUCURSALESBAJ(" + sentenciaStore.toString() + ")");

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de sucursales en tipo de cuentas por sucursal", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});

		return mensaje;
	}// fin
}
