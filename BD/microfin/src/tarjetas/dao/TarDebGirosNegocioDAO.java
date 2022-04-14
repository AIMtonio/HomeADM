package tarjetas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tarjetas.bean.TarDebGirosAcepIndividualBean;
import tarjetas.bean.TarDebGirosNegocioBean;
import tarjetas.bean.TarDebLimiteTipoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebGirosNegocioDAO extends BaseDAO{

	public TarDebGirosNegocioDAO() {
		super();
	}
	/*Alta de Giros de Negocio por Tipo de Tarjeta*/
	public MensajeTransaccionBean altaGiroNegocioTarjeta(final TarDebGirosNegocioBean tarDebGirosNegocioBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARDEBGIROSXTIPOALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoTarjetaDebID",Utileria.convierteEntero(tarDebGirosNegocioBean.getTipoTarjetaDebID()));
								sentenciaStore.setString("Par_GiroID",tarDebGirosNegocioBean.getGiroID());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la alta de Giros de Negocios por Tipo de Tarjeta", e);
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

	/*Baja de Giros de Negocio por Tipo de Tarjeta*/
	public MensajeTransaccionBean bajaGiroNegocioTarjeta(TarDebGirosNegocioBean tarDebGirosNegocioBean) {
		String query = "call TARDEBGIROSXTIPOBAJ(?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tarDebGirosNegocioBean.getTipoTarjetaDebID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"bajaGiroNegocioTarjeta",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGIROSXTIPOBAJ(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
				mensaje.setDescripcion(resultSet.getString(2));
				mensaje.setNombreControl(resultSet.getString(3));
				return mensaje;
			}
		});

		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}

	/* Consulta de Giros de Negocio por Tipo de Tarjeta*/
	public TarDebGirosNegocioBean consultaGiroTipoTarjeta(int tipoConsulta,TarDebGirosNegocioBean tarDebGirosNegocioBean){

		String query = "call TARDEBGIROSXTIPOCON(?,?,   ?,?,?,?,?,?,?);";

		Object[] parametros = {
				tarDebGirosNegocioBean.getTipoTarjetaDebID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"consultaGiroTipoTarjeta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGIROSXTIPOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				TarDebGirosNegocioBean tipoTarjetaDeb= new TarDebGirosNegocioBean();
				tipoTarjetaDeb.setTipoTarjetaDebID(resultSet.getString(1));
				tipoTarjetaDeb.setNombreTarjeta(resultSet.getString(2));
				tipoTarjetaDeb.setTipo(resultSet.getString(4));

					return tipoTarjetaDeb;
			}
		});

		return matches.size() > 0 ? (TarDebGirosNegocioBean) matches.get(0) : null;
	}

	// Lista para el grid de Giros de Negocio por Tipo de Tarjeta
	public List listaGiroTipoTarjeta(TarDebGirosNegocioBean tarDebGirosNegocioBean, int tipoLista){
	List listaGrid = null;
	try{

		String query = "call TARDEBGIROSXTIPOLIS(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {
					tarDebGirosNegocioBean.getTipoTarjetaDebID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaGiroTipoTarjeta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGIROSXTIPOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarDebGirosNegocioBean giroTipoTarjeta = new TarDebGirosNegocioBean();
				giroTipoTarjeta.setTipoTarjetaDebID(resultSet.getString(1));
				giroTipoTarjeta.setGiroID(resultSet.getString(2));
				giroTipoTarjeta.setDescripcion(resultSet.getString(3));

				return giroTipoTarjeta;
			}
		});
		listaGrid= matches;
	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Giros de Negocios por Tipo de Tarjeta ", e);

	}
	return listaGrid;
}

	public MensajeTransaccionBean grabaGiroTipoTarjeta(final TarDebGirosNegocioBean tarDebGirosNegocioBean,final List listaGirosTipoTarjeta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						TarDebGirosNegocioBean rangoGirosBean;

					for(int i=0; i<listaGirosTipoTarjeta.size(); i++){
						rangoGirosBean = (TarDebGirosNegocioBean)listaGirosTipoTarjeta.get(i);
						mensajeBean = altaGiroNegocioTarjeta(rangoGirosBean);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Giros Agregados Exitosamente");
					mensajeBean.setNombreControl("tipoTarjetaDebID");
					mensajeBean.setConsecutivoInt(tarDebGirosNegocioBean.getTipoTarjetaDebID());
				}
					catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al registrar los giros ", e);
					}
					return mensajeBean;
					}
			});
		return mensaje;
		}

	public MensajeTransaccionBean modGiroTipoTarjeta(final TarDebGirosNegocioBean tarDebGirosNegocioBean, final List listaGirosTipoTarjeta) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						TarDebGirosNegocioBean rangoGirosBean;
						mensajeBean = bajaGiroNegocioTarjeta(tarDebGirosNegocioBean);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						for(int i=0; i<listaGirosTipoTarjeta.size(); i++){
							rangoGirosBean = (TarDebGirosNegocioBean)listaGirosTipoTarjeta.get(i);
							mensajeBean = altaGiroNegocioTarjeta(rangoGirosBean);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Giros Modificados Exitosamente");
						mensajeBean.setNombreControl("tipoTarjetaDebID");
						mensajeBean.setConsecutivoInt(tarDebGirosNegocioBean.getTipoTarjetaDebID());
					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al modificar los giros", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
}