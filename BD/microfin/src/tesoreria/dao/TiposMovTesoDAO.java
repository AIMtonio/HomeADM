package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;


import general.bean.MensajeTransaccionBean;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import tesoreria.bean.TiposMovTesoBean;

public class TiposMovTesoDAO extends BaseDAO{

	public TiposMovTesoDAO(){
		super();
	}

	final String Conciliacion="C";


	public MensajeTransaccionBean altaTiposMovTeso(final TiposMovTesoBean tiposMovTesoBean) {
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
									String query = "call TIPOSMOVTESOALT(?,?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Descripcion",tiposMovTesoBean.getDescripcion());
									sentenciaStore.setString("Par_TipoMovimi",tiposMovTesoBean.getTipoMovimiento());
									sentenciaStore.setString("Par_CtaContable",tiposMovTesoBean.getCuentaContable());
									sentenciaStore.setString("Par_CtaMayor",tiposMovTesoBean.getCuentaMayor());
									sentenciaStore.setString("Par_CtaEditable",tiposMovTesoBean.getCuentaEditable());
									sentenciaStore.setString("Par_NaturaConta",tiposMovTesoBean.getNaturaContable());


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.CHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

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

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de tipos de movimiento de tesoreria", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	public MensajeTransaccionBean ModTiposMovTeso(final TiposMovTesoBean tiposMovTesoBean) {
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
									String query = "call TIPOSMOVTESOMOD(?,?,?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipMovTesID",tiposMovTesoBean.getTipoMovTesoID());
									sentenciaStore.setString("Par_Descripcion",tiposMovTesoBean.getDescripcion());
									sentenciaStore.setString("Par_TipoMovimi",tiposMovTesoBean.getTipoMovimiento());
									sentenciaStore.setString("Par_CtaContable",tiposMovTesoBean.getCuentaContable());
									sentenciaStore.setString("Par_CtaMayor",tiposMovTesoBean.getCuentaMayor());
									sentenciaStore.setString("Par_CtaEditable",tiposMovTesoBean.getCuentaEditable());
									sentenciaStore.setString("Par_NaturaConta",tiposMovTesoBean.getNaturaContable());


									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.CHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));


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

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificaciones de tipo de movimiento de tesoreria", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// LISTA
	public List listaTiposMovTeso(int tipoLista, TiposMovTesoBean tiposMovTesoBean){


		List resultado= null;
		try{
		String query = "call TIPOSMOVTESOLIS (?,?,?, ?,?,?,?,?,?,? );";

		Object[] parametros = {
				tiposMovTesoBean.getDescripcion(),
				tiposMovTesoBean.getTipoMovimiento(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"Presupesto.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSMOVTESOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			@Override
			public Object mapRow(ResultSet resultSet, int index) throws SQLException {
				// TODO Auto-generated method stub
				TiposMovTesoBean tiposMovTesoBean = new TiposMovTesoBean();

				tiposMovTesoBean.setTipoMovTesoID(resultSet.getString("TipoMovTesoID"));
				tiposMovTesoBean.setDescripcion(resultSet.getString("Descripcion"));

				return tiposMovTesoBean;
			}

		});

		resultado= matches;
		} catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipo de movimientos de tesoreria", e);

		}
		return resultado;
	}

	// metodo de lista para combobox de TIPOSMOVTESO de tipo Conciliacion
	public List listaTiposMovTesoConciliacion(int tipoLista, TiposMovTesoBean tiposMovTesoBean){
		List resultado= null;
		try{
			String query = "call TIPOSMOVTESOLIS (?,?,?, ?,?,?,?,?,?,? );";
			Object[] parametros = {
					tiposMovTesoBean.getDescripcion(),
					tiposMovTesoBean.getTipoMovimiento(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposMovTesoDAO.listaTiposMovTesoConciliacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSMOVTESOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int index) throws SQLException {
					TiposMovTesoBean tiposMovTesoBean = new TiposMovTesoBean();
					tiposMovTesoBean.setTipoMovTesoID(resultSet.getString("TipoMovTesoID"));
					tiposMovTesoBean.setDescripcion(resultSet.getString("Descripcion"));
					return tiposMovTesoBean;
				}
			});
			resultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de tipo de movimientos de tesoreria", e);
		}
		return resultado;
	}


	//CONSULTA
	public TiposMovTesoBean consultaTiposMovTeso(int tipoCon, TiposMovTesoBean tiposMovTesoBean){


		String query = "call TIPOSMOVTESOCON (?,?,?, ?,?,?,?,?,?,? );";

		Object[] parametros = {
				tiposMovTesoBean.getTipoMovTesoID(),
				tiposMovTesoBean.getTipoMovimiento(),
				tipoCon,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"Presupesto.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSMOVTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			@Override
			public Object mapRow(ResultSet resultSet, int index) throws SQLException {
				// TODO Auto-generated method stub
				TiposMovTesoBean tiposMovTesoBean = new TiposMovTesoBean();

				tiposMovTesoBean.setTipoMovTesoID(resultSet.getString("TipoMovTesoID"));
				tiposMovTesoBean.setDescripcion(resultSet.getString("Descripcion"));
				tiposMovTesoBean.setEstatus(resultSet.getString("Estatus"));
				tiposMovTesoBean.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
				tiposMovTesoBean.setCuentaContable(resultSet.getString("CuentaContable"));

				tiposMovTesoBean.setCuentaMayor(resultSet.getString("CuentaMayor"));
				tiposMovTesoBean.setCuentaEditable(resultSet.getString("CuentaEditable"));
				tiposMovTesoBean.setNaturaContable(resultSet.getString("NaturaContable"));

				return tiposMovTesoBean;
			}

		});

		return matches.size() > 0 ? (TiposMovTesoBean) matches.get(0) : null;
	}

	//CONSULTA FORANEA
	public TiposMovTesoBean consultaTiposMovTesoForanea(int tipoCon, TiposMovTesoBean tiposMovTesoBean){
		TiposMovTesoBean tiposMovTesoBeanConsulta = new TiposMovTesoBean();
		try{
			String query = "call TIPOSMOVTESOCON (?,?,?, ?,?,?,?,?,?,? );";
			Object[] parametros = {
					tiposMovTesoBean.getTipoMovTesoID(),
					tiposMovTesoBean.getTipoMovimiento(),
					tipoCon,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"Presupesto.conFolioOperacinon",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSMOVTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int index) throws SQLException {
					TiposMovTesoBean tiposMovTesoBean = new TiposMovTesoBean();
					tiposMovTesoBean.setTipoMovTesoID(resultSet.getString("TipoMovTesoID"));
					tiposMovTesoBean.setDescripcion(resultSet.getString("Descripcion"));
					tiposMovTesoBean.setCuentaContable(resultSet.getString("CuentaContable"));
					tiposMovTesoBean.setCuentaMayor(resultSet.getString("CuentaMayor"));
					tiposMovTesoBean.setCuentaEditable(resultSet.getString("CuentaEditable"));

					tiposMovTesoBean.setNaturaContable(resultSet.getString("NaturaContable"));
					return tiposMovTesoBean;
				}

			});
			tiposMovTesoBeanConsulta= matches.size() > 0 ? (TiposMovTesoBean) matches.get(0) : null;
		}catch(Exception e){}
		return tiposMovTesoBeanConsulta;
	}

}
