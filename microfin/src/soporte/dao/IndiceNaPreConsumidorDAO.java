package soporte.dao;

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

import soporte.bean.IndiceNaPreConsumidorBean;

public class IndiceNaPreConsumidorDAO extends BaseDAO{

	public IndiceNaPreConsumidorDAO(){
		super();
	}

	/* Registro de Indice Nacional de Precios al Consumidor */
	public MensajeTransaccionBean registroIndiceNaPreConsumidor(final IndiceNaPreConsumidorBean indiceNaPreConBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call INDICENAPRECONSALT(" +
																"?,?,?," +
																"?,?,?,	 " +		//Parametros de salida
																"?,?,?,?,?,?,?);"; 	// Parametros de Auditoria
						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(indiceNaPreConBean.getAnio()));
						sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(indiceNaPreConBean.getMes()));
						sentenciaStore.setDouble("Par_ValorINPC",Utileria.convierteDoble(indiceNaPreConBean.getValorINPC()));

						//Parametros de Salida
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

						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

						return sentenciaStore;
					}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en registro de Indice Nacional de Precios al Consumidor", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* modificacion de Indice Nacional de Precios al Consumidor */
	public MensajeTransaccionBean modificaIndiceNaPreConsumidor(final IndiceNaPreConsumidorBean indiceNaPreConBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
					public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call INDICENAPRECONSMOD(" +
																"?,?,?," +
																"?,?,?,	 " +		//Parametros de salida
																"?,?,?,?,?,?,?);"; 	// Parametros de Auditoria
						CallableStatement sentenciaStore = arg0.prepareCall(query);

						sentenciaStore.setInt("Par_Anio",Utileria.convierteEntero(indiceNaPreConBean.getAnio()));
						sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(indiceNaPreConBean.getMes()));
						sentenciaStore.setDouble("Par_ValorINPC",Utileria.convierteDoble(indiceNaPreConBean.getValorINPC()));

						//Parametros de Salida
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

						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

						return sentenciaStore;
					}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
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
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de Indice Nacional de Precios al Consumidor", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consulta de Indice Nacional de Precios al Consumidor */
	public IndiceNaPreConsumidorBean consultaPrincipal(int tipoConsulta, IndiceNaPreConsumidorBean bean) {
		IndiceNaPreConsumidorBean indiceNaPreConsumidor = null;

		try{
			String query = "call INDICENAPRECONSCON(?,?,?," +
													"?,?,?,?,?,?,?);"; //Parametros de auditoria
			Object[] parametros = {
				Utileria.convierteEntero(bean.getAnio()),
				Utileria.convierteEntero(bean.getMes()),
				tipoConsulta,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"IndiceNaPreConsumidorDAO.consultaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INDICENAPRECONSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {

					IndiceNaPreConsumidorBean indiceNaPreConsumidor = new IndiceNaPreConsumidorBean();

					indiceNaPreConsumidor.setAnio(resultSet.getString("Anio"));
					indiceNaPreConsumidor.setMes(resultSet.getString("Mes"));
					indiceNaPreConsumidor.setValorINPC(resultSet.getString("ValorINPC"));

					return indiceNaPreConsumidor;
				}
			});
			indiceNaPreConsumidor= matches.size() > 0 ? (IndiceNaPreConsumidorBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta Principal Indice Nacional de Precios al Consumidor", e);
		}
		return indiceNaPreConsumidor;
	}
}