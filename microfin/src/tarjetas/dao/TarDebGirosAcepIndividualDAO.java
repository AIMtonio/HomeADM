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
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebGirosAcepIndividualDAO extends BaseDAO{

	public TarDebGirosAcepIndividualDAO() {
		super();
	}
	/*Alta de giros aceptados por tarjeta individual*/
	public MensajeTransaccionBean altaGirosTarjetas(final TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call TARDEBGIROSALT(?,?,?,?,?,   ?,?,?,?,?,  ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_TarjetaDebID",tarDebGirosAcepIndividualBean.getTarjetaID());
								sentenciaStore.setString("Par_GiroID",tarDebGirosAcepIndividualBean.getGiroID());

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la alta de Giros Aceptados por Tarjeta Individual", e);
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


	/*Baja de giros aceptados por tarjeta individual*/
	public MensajeTransaccionBean bajaGirosTarjetas(TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean) {
		String query = "call TARDEBGIROSBAJ(?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tarDebGirosAcepIndividualBean.getTarjetaID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"bajaGirosTarjetas",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGIROSBAJ(  " + Arrays.toString(parametros) + ")");

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
	// Consulta giros aceptados por tarjeta individual
	public TarDebGirosAcepIndividualBean consultaTarjetaIndividual(int tipoConsulta,TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean){

		String query = "call TARJETADEBITOCON(?,?,?,?,?, ?, ?,   ?,?,?,?, ?,?,?);";

				Object[] parametros = {
						tarDebGirosAcepIndividualBean.getTarjetaID(),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"consultaTarjetaIndividual",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO

						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARJETADEBITOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						TarDebGirosAcepIndividualBean girosTarDebIndiv = new TarDebGirosAcepIndividualBean();
						girosTarDebIndiv.setTarjetaID(resultSet.getString(1));
						girosTarDebIndiv.setEstatus(resultSet.getString(2));
						girosTarDebIndiv.setClienteID(
					    		 (resultSet.getString(3)!=null) ?
										   Utileria.completaCerosIzquierda(
												   Utileria.convierteEntero(resultSet.getString(3)
														   ),TarDebGirosAcepIndividualBean.LONGITUD_ID) : Constantes.STRING_VACIO  );
						girosTarDebIndiv.setNombreCompleto(resultSet.getString(4));
						girosTarDebIndiv.setCoorporativo(resultSet.getString(5));
					   // bitacoraEstatusTarDeb.setCuentaAho(resultSet.getString(6));
						girosTarDebIndiv.setCuentaAho(
								   (resultSet.getString(6)!=null) ?
										   Utileria.completaCerosIzquierda(
												   Utileria.convierteEntero(resultSet.getString(6)
														   ),TarDebGirosAcepIndividualBean.LONGITUD_ID) : Constantes.STRING_VACIO  );

						girosTarDebIndiv.setNombreTipoCuenta(resultSet.getString(7));
						girosTarDebIndiv.setTipoTarjetaID(resultSet.getString(8));
						girosTarDebIndiv.setNombreTarjeta(resultSet.getString(9));
						girosTarDebIndiv.setIdentificacionSocio(resultSet.getString("IdentificacionSocio"));

							return girosTarDebIndiv;


					}
				});

				return matches.size() > 0 ? (TarDebGirosAcepIndividualBean) matches.get(0) : null;


			}
	// Lista para el grid de giros aceptados por tarjeta individual
			public List listaGirosTarjIndividual(TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean, int tipoLista){
			List listaGrid = null;
			try{

				String query = "call TARDEBGIROSLIS(?,?,?,?,?,  ?,?,?,?);";
				Object[] parametros = {
							tarDebGirosAcepIndividualBean.getTarjetaID(),
							tipoLista,

							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"listaGirosTarjIndividual",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO
							};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARDEBGIROSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						TarDebGirosAcepIndividualBean giroTarIndividual = new TarDebGirosAcepIndividualBean();
						giroTarIndividual.setTarjetaID(resultSet.getString(1));
						giroTarIndividual.setGiroID(resultSet.getString(2));
						giroTarIndividual.setDescripcion(resultSet.getString(3));

						return giroTarIndividual;
					}
				});
				listaGrid= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Lista de Giros Aceptados por Tarjeta Individual ", e);

			}
			return listaGrid;
		}

			public MensajeTransaccionBean grabaGiroTarIndividual(final TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean,final List listaGirosTarIndividual) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
							TarDebGirosAcepIndividualBean rangoGirosBean;

							for(int i=0; i<listaGirosTarIndividual.size(); i++){
								rangoGirosBean = (TarDebGirosAcepIndividualBean)listaGirosTarIndividual.get(i);
								mensajeBean = altaGirosTarjetas(rangoGirosBean);


								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Giro Agregado Exitosamente");
							mensajeBean.setNombreControl("tarjetaID");
							mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
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

		public MensajeTransaccionBean modgiroTarjetaIndividual(final TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean, final List listaGirosTarIndividual) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							TarDebGirosAcepIndividualBean rangoGirosBean;
							mensajeBean = bajaGirosTarjetas(tarDebGirosAcepIndividualBean);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}

							for(int i=0; i<listaGirosTarIndividual.size(); i++){
								rangoGirosBean = (TarDebGirosAcepIndividualBean)listaGirosTarIndividual.get(i);
								mensajeBean = altaGirosTarjetas(rangoGirosBean);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Giro Modificado Exitosamente");
							mensajeBean.setNombreControl("tarjetaID");
							mensajeBean.setConsecutivoInt(Constantes.STRING_CERO);
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


