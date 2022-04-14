package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.PresuSucurGridBean;
import tesoreria.bean.PresupuestoSucursalBean;
import tesoreria.bean.RepPresupSucursalBean;


public class PresupuestoSucursalDAO extends BaseDAO {


	public PresupuestoSucursalDAO() {
		super();
	}
	public MensajeTransaccionBean ActPresupSucursal(final List listaGridDetalle,
			final PresupuestoSucursalBean presupSucursalBean, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					PresuSucurGridBean presSucGridBean;
                    int actualizaEstatus=1;
					mensajeBean = actEstatusEncabezado(presupSucursalBean,actualizaEstatus);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					String consecutivo = presupSucursalBean.getFolio();

					int folioOperacion = Utileria.convierteEntero(consecutivo);



					for(int i=0; i<listaGridDetalle.size(); i++){
						presSucGridBean = (PresuSucurGridBean) listaGridDetalle.get(i);
						if(presSucGridBean.getFolioID().equals("N")){
						mensajeBean = altaCuerpo(presSucGridBean, folioOperacion);
						}
                        if(presSucGridBean.getFolioID()!="N"){
                        	mensajeBean = ActualizaCuerpo(presSucGridBean, folioOperacion,tipoActualizacion);
                        }
                        	if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);

					if(presupSucursalBean.getEstatusPre().equals("C") &&
							parametrosAuditoriaBean.getUsuario()== Utileria.convierteEntero(presupSucursalBean.getUsuario())){
						mensajeBean.setDescripcion("El presupuesto con folio: "+consecutivo+" ha sido cerrado. ");
					}
					else{
					mensajeBean.setDescripcion("El presupuesto con folio: "+consecutivo+" ha sido modificado. ");
					}

					mensajeBean.setNombreControl("folio");
					mensajeBean.setConsecutivoString(consecutivo);
					mensajeBean.setConsecutivoInt(consecutivo);

				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de presupuestos de sucursal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}
	public MensajeTransaccionBean altaPresupSucursal(final List listaGridDetalle,
														final PresupuestoSucursalBean presupSucursalBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					PresuSucurGridBean presSucGridBean;

					mensajeBean = altaEncabezado(presupSucursalBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					String consecutivo = mensajeBean.getConsecutivoInt();

					int folioOperacion = Utileria.convierteEntero(consecutivo);



					for(int i=0; i<listaGridDetalle.size(); i++){
						presSucGridBean = (PresuSucurGridBean) listaGridDetalle.get(i);

						mensajeBean = altaCuerpo(presSucGridBean, folioOperacion);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					if(presupSucursalBean.getEstatusPre().equals("C")){
						mensajeBean.setDescripcion("El presupuesto ha sido cerrado con folio: "+consecutivo);
					}
					else{
					mensajeBean.setDescripcion("El presupuesto ha sido agregado con folio: "+consecutivo);
					}
					mensajeBean.setNombreControl("folio");
					mensajeBean.setConsecutivoString(consecutivo);
					mensajeBean.setConsecutivoInt(consecutivo);

				}catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de presupuesto de sucursal", e);
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

	}





	//Alta del Encabezado
	public MensajeTransaccionBean altaEncabezado( PresupuestoSucursalBean presSucBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try{

			String query = "call PRESUCURENCALT(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(presSucBean.getMesPresupuesto()),
					Utileria.convierteEntero(presSucBean.getAnioPresupuesto()),
					Utileria.convierteEntero(presSucBean.getUsuario()),
					parametrosAuditoriaBean.getFecha(),
					Utileria.convierteEntero(presSucBean.getSucursal()),
					presSucBean.getEstatusPre(),


					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PresupuestoSucursalDao.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURENCALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					mensaje.setConsecutivoInt(resultSet.getString(4));
					return mensaje;
				}
			});
			mensaje = matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			return mensaje;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de encabezados de presupuesto sucursal", e);
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}
//,,,,,,,,,,,,,,,,,,,,,

	public MensajeTransaccionBean actEstatusEncabezado( PresupuestoSucursalBean presSucBean, int numActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{

			String query = "call PRESUCURENCACT(?,?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(presSucBean.getFolio()),
					Utileria.convierteEntero(presSucBean.getUsuario()),
					parametrosAuditoriaBean.getFecha(),
					Utileria.convierteEntero(presSucBean.getSucursal()),
				 	presSucBean.getEstatusPre(),
					numActualizacion,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PresupuestoSucursalDao.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURENCACT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					mensaje.setConsecutivoInt(resultSet.getString(4));
					return mensaje;
				}
			});
			mensaje = matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			return mensaje;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de status de encabezado", e);
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}


	//Alta del Destalle
	public MensajeTransaccionBean altaCuerpo(PresuSucurGridBean preSucBean, int folio){



		MensajeTransaccionBean mensaje = null;

		String query = "call PRESUCURDETALT (?,?,?,?,?, ?,?,?,?,?,  ?,?,?);";
		try{
		Object parametros[]={

						folio,
						Utileria.convierteEntero(preSucBean.getGridConcepto()),
						preSucBean.getGridDescripcion(),
						preSucBean.getGridEstatus(),
						Utileria.convierteDoble(preSucBean.getGridMonto()),
						preSucBean.getObservaciones(),

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"OperDispersionDao.grabaListaDispersion",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
	        	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURDETALT(" + Arrays.toString(parametros) +")");
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

				mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;

			} catch (Exception e) {
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuerpo de presupuesto de sucursal", e);
				if(mensaje.getNumero()==0){
					mensaje.setNumero(999);
				}
				mensaje.setDescripcion(e.getMessage());
			}

			return mensaje;

	}//...............................

	public MensajeTransaccionBean ActualizaCuerpo(final PresuSucurGridBean preSucBean, final int encabezadoID, final int tipoAct){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PRESUCURDETACT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?,?,?,?, ?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(preSucBean.getFolioID()));
							sentenciaStore.setInt("Par_EncabezadoID", encabezadoID);
							sentenciaStore.setInt("Par_Concepto", Utileria.convierteEntero(preSucBean.getGridConcepto()));
							sentenciaStore.setString("Par_Descripcion", preSucBean.getGridDescripcion());
							sentenciaStore.setString("Par_Estatus", preSucBean.getGridEstatus());

							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(preSucBean.getGridMonto()));
							sentenciaStore.setString("Par_Observaciones", preSucBean.getObservaciones());
							sentenciaStore.setInt("Num_Act", tipoAct);
							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
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
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado");
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado");
					}else
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualiza cuerpo de presupuesto sucural", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}// fin ActualizaCuerpo

	public PresupuestoSucursalBean consultaFolio(int tipoConsulta, PresupuestoSucursalBean preSucBean){
		String query = "call PRESUPSUCURCON (?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object parametros[] = {

				Utileria.convierteEntero(preSucBean.getFolio()),
				Utileria.convierteEntero(preSucBean.getMesPresupuesto()),
				Utileria.convierteEntero(preSucBean.getAnioPresupuesto()),
				Utileria.convierteEntero(preSucBean.getSucursal()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"Presupesto.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUPSUCURCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			@Override
			public Object mapRow(ResultSet resultSet, int index)
			throws SQLException {
				// TODO Auto-generated method stub
				PresupuestoSucursalBean preSucBean = new PresupuestoSucursalBean();

				preSucBean.setFolio(resultSet.getString("FolioID"));
				preSucBean.setMesPresupuesto(resultSet.getString("MesPresupuesto"));
				preSucBean.setAnioPresupuesto(resultSet.getString("AnioPresupuesto"));
				preSucBean.setUsuario(resultSet.getString("UsuarioElaboro"));
				preSucBean.setSucursal(resultSet.getString("SucursalOrigen"));
				preSucBean.setFecha(resultSet.getString("Fecha"));
				preSucBean.setEstatusPre(resultSet.getString("Estatus"));
				preSucBean.setNombreUsuario(resultSet.getString("Nombre"));
				return preSucBean;
			}


		});

		return matches.size() > 0 ? (PresupuestoSucursalBean) matches.get(0) : null ;


	}



	public List listaGrid(int tipoLista, PresupuestoSucursalBean preSucBean){


		String query = "call PRESUCURDETCON (?,?,?,?,?, ?,?,?,?,?,?,? );";

		Object[] parametros = {

				Utileria.convierteEntero(preSucBean.getFolio()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"Presupesto.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURDETCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			@Override
			public Object mapRow(ResultSet resultSet, int index) throws SQLException {
				// TODO Auto-generated method stub
				PresuSucurGridBean preSucGridBean = new PresuSucurGridBean();
				preSucGridBean.setFolioID(String.valueOf(resultSet.getString("FolioID")));
				preSucGridBean.setGridConcepto(String.valueOf(resultSet.getString("Concepto")));
				preSucGridBean.setGridDescripcion(resultSet.getString("Descripcion"));
				preSucGridBean.setGridEstatus(resultSet.getString("Estatus"));
				preSucGridBean.setGridMonto(String.valueOf(resultSet.getString("Monto")));
				preSucGridBean.setMontoDispon(String.valueOf(resultSet.getString("MontoDispon")));
				preSucGridBean.setObservaciones(resultSet.getString("Observaciones"));

				return preSucGridBean;
			}

		});



		return matches;

	}

	public List listaPartidaPre (PresupuestoSucursalBean preSucBean, int tipoLista){

		String query = "call PRESUCURDETLIS(?,?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
					preSucBean.getConceptoPet(),
					Utileria.convierteEntero(preSucBean.getSucursal()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURDETLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PresupuestoSucursalBean preSucBean = new PresupuestoSucursalBean();

				preSucBean.setFolio(resultSet.getString("FolioID"));
				preSucBean.setMontoPet(resultSet.getString("Monto"));
				preSucBean.setDescripcionPet(resultSet.getString("Descripcion"));
				return preSucBean;
			}
		});
		return matches;
	}


	public List listaPresupuestosPendientes (PresupuestoSucursalBean preSucBean, int tipoLista){
		List listaResultado = null;
		try {
		String query = "call PRESUCURENCLIS(?,?,?, ?,?,?,?,?,?,?);";

		Object[] parametros = {
					preSucBean.getNombreSucursal(),
					preSucBean.getFecha(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURENCLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PresupuestoSucursalBean preSucSalidaBean = new PresupuestoSucursalBean();

				preSucSalidaBean.setFolio(resultSet.getString("FolioID"));
				preSucSalidaBean.setSucursal(resultSet.getString("SucursalOrigen"));
				preSucSalidaBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
				preSucSalidaBean.setUsuario(resultSet.getString("UsuarioElaboro"));
				preSucSalidaBean.setNombreUsuario(resultSet.getString("NombreCompleto"));

				return preSucSalidaBean;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de presupuesto pendiente", e);
		}
		return listaResultado;
	}



	public PresupuestoSucursalBean consultaPresupConcep(final  PresupuestoSucursalBean presupuesto, int tipoConsulta){
		//Query consulta el presupuesto de un tipo en especifico tipo,mes,año,sucursal y aprobado
			String query = "call PRESUCURDETCON (?,?,?,?,?, ?,?,?,?,?,?,? );";

		Object[] parametros = {

				Utileria.convierteEntero(presupuesto.getFolio()),
				Utileria.convierteEntero(presupuesto.getConceptoPet()),
				Utileria.convierteEntero(presupuesto.getSucursal()),
				presupuesto.getFecha(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"Presupesto.conFolioOperacinon",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUCURDETCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {



				PresupuestoSucursalBean presupAprobado = new PresupuestoSucursalBean();

				presupAprobado.setFolio(resultSet.getString("FolioID"));
				presupAprobado.setDescripcionPet(resultSet.getString("Descripcion"));
				presupAprobado.setMontoPet(String.valueOf(resultSet.getString("Monto")));
				presupAprobado.setMontoDispon(String.valueOf(resultSet.getString("MontoDispon")));


				return presupAprobado;
			}
		});
		return matches.size() > 0 ? (PresupuestoSucursalBean) matches.get(0) : null;

	}
	//este es el reporte para excel
	public List presucrepExcel (PresupuestoSucursalBean preSucBean, int tipoLista){
		List listaResultado = null;
		try {
		String query = "call PRESUPUESTOSREP(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?);";

		Object[] parametros = {
				Utileria.convierteEntero(preSucBean.getAnioInicio()),
				Utileria.convierteEntero(preSucBean.getMesInicio()),
				Utileria.convierteEntero(preSucBean.getAnioFin()),
				Utileria.convierteEntero(preSucBean.getMesFin()),
					preSucBean.getEstatusPre(),
					preSucBean.getEstatusPet(),
					preSucBean.getSucursal(),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRESUPUESTOSREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RepPresupSucursalBean preSucSalidaBean = new RepPresupSucursalBean();

				preSucSalidaBean.setFolioEncID(resultSet.getString("FolioEncID"));
				preSucSalidaBean.setNombreMes(resultSet.getString("NombreMes"));
				preSucSalidaBean.setMesPresupuesto(resultSet.getString("MesPresupuesto"));
				preSucSalidaBean.setAnioPresupuesto(resultSet.getString("AnioPresupuesto"));
				preSucSalidaBean.setFecha(resultSet.getString("Fecha"));
				preSucSalidaBean.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
				preSucSalidaBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
				preSucSalidaBean.setUsuarioElaboro(resultSet.getString("UsuarioElaboro"));
				preSucSalidaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				preSucSalidaBean.setEstatusEnc(resultSet.getString("EstatusEnc"));
				preSucSalidaBean.setFolioID(resultSet.getString("FolioID"));
				preSucSalidaBean.setConcepto(resultSet.getString("Concepto"));
				preSucSalidaBean.setNombreConcep(resultSet.getString("NombreConcep"));
				preSucSalidaBean.setDescripcion(resultSet.getString("Descripcion"));
				preSucSalidaBean.setMonto(resultSet.getString("Monto"));
				preSucSalidaBean.setMontoDispon(resultSet.getString("MontoDispon"));
				preSucSalidaBean.setEstatusDet(resultSet.getString("EstatusDet"));

				return preSucSalidaBean;
			}
		});
		listaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en presupuesto de sucursal", e);
		}
		return listaResultado;
	}


}
