
package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import herramientas.Utileria;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


import nomina.bean.GeneraDomiciliacionPagosBean;

public class GeneraDomiciliacionPagosDAO extends BaseDAO{
	public GeneraDomiciliacionPagosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}

	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int bajaDomiciliacion   = 2;		// Baja de Domiciliación de Pagos
	}

	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Domiciliacion{
		int conParamArchivo		= 3;		// Consulta de Parámetros de Archivos de Nómina
	}

	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Domiciliacion{
		int domiciliaPagos		= 4;		// Lista de Domiciliación de Pagos
		int layoutDomPagos		= 6;		// Lista de Domiciliación de Pagos para generar el Layout
	}

	/**
	 *
	 * @param listaBean : Metodo para mandar a llamar al método para generar la Domiciliación de Pagos
	 * @return
	 */

	public MensajeTransaccionBean generaDomiciliacionPagos(final GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					List<GeneraDomiciliacionPagosBean> listaDomiciliacion = null;

					// Lista de Domiciliación de Pagos
					listaDomiciliacion = listaDomiciliacionPagosPag(generaDomiciliacionPagosBean, Enum_Lis_Domiciliacion.domiciliaPagos);
					GeneraDomiciliacionPagosBean generaDomiciliacion = null;
					GeneraDomiciliacionPagosBean generaDomiciliacionIter = null;

					Iterator<GeneraDomiciliacionPagosBean> itera = null;
					itera = listaDomiciliacion.iterator();

					String folioID = "";
					while(itera.hasNext()){
						generaDomiciliacion = new GeneraDomiciliacionPagosBean();

						generaDomiciliacionIter = itera.next();

						generaDomiciliacion.setFolioID(generaDomiciliacionIter.getFolioID());
						generaDomiciliacion.setClienteID(generaDomiciliacionIter.getClienteID());
						generaDomiciliacion.setInstitucionID(generaDomiciliacionIter.getInstitucionID());
						generaDomiciliacion.setCuentaClabe(generaDomiciliacionIter.getCuentaClabe());
						generaDomiciliacion.setCreditoID(generaDomiciliacionIter.getCreditoID());
						generaDomiciliacion.setMontoExigible(generaDomiciliacionIter.getMontoExigible());

						// Registro de Información de Domiciliación de Pagos
						mensajeBean = generaDomiciliacionPagos(generaDomiciliacion,parametrosAuditoriaBean.getNumeroTransaccion());

						if(mensajeBean.getNumero() != 0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						folioID = generaDomiciliacion.getFolioID();
					}

					// Registro de Encabezados del Layout de Domiciliación de Pagos.
					mensajeBean = altaEncabezadoLayout(generaDomiciliacionPagosBean,folioID,parametrosAuditoriaBean.getNumeroTransaccion());

					if(mensajeBean.getNumero() != 0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					else{
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Generación del Layout de Domiciliación de Pagos realizada Exitosamente.");
						mensajeBean.setNombreControl("agregar");
						mensajeBean.setConsecutivoInt("0");
					}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Generar Layout Domiciliación de Pagos", e);
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

	/**
	 *
	 * @param generaDomiciliacionPagosBean : Registro de Información de Domiciliación de Pagos
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean generaDomiciliacionPagos(final GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean,final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIACIONPAGOSALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(generaDomiciliacionPagosBean.getFolioID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(generaDomiciliacionPagosBean.getClienteID()));
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitucionID()));
									sentenciaStore.setString("Par_CuentaClabe",generaDomiciliacionPagosBean.getCuentaClabe());
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(generaDomiciliacionPagosBean.getCreditoID()));

									sentenciaStore.setDouble("Par_MontoExigible",Utileria.convierteDoble(generaDomiciliacionPagosBean.getMontoExigible()));

									//Parametros de OutPut
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
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(this.getClass()+" - "+"Error en generar la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean : Bean de registro de Encabezados del Layout de Domiciliación de Pagos.
	 * @param numeroTransaccion : Número de Transacción
	 * @return
	 */
	public MensajeTransaccionBean altaEncabezadoLayout(final GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, final String folioID,
			final long numeroTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call DOMICILIACIONPAGOSENCALT(?,?,?,?,?,	?,?,?,?,?,	?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_FolioID",Utileria.convierteLong(folioID));
									sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(generaDomiciliacionPagosBean.getFechaSistema()));

									//Parametros de OutPut
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
									sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

									loggerSAFI.info(this.getClass()+" - "+sentenciaStore.toString());
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

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+"Error al registrar el Encabezado de la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean : Genera Layout Domiciliación de Pagos.
	 */
	public void generaLayout(List generaDomiciliacionPagosBean, long consecutivo,HttpServletResponse response){
		try{
			GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();

			generaDomiciliacionPagos.setConsecutivoID(String.valueOf(consecutivo));
			generaDomiciliacionPagos = consultaParametrosArchivo(generaDomiciliacionPagos,Enum_Con_Domiciliacion.conParamArchivo);
			ServletOutputStream ouputStream=null;
			BufferedWriter writer;
			String nombreArchivo;

			nombreArchivo = generaDomiciliacionPagos.getNombreArchivo()+".pag";

			writer = new BufferedWriter(new FileWriter(nombreArchivo));

			String importeTotal = generaDomiciliacionPagos.getImporteTotal().replace(".", "");

			String espacios ="                                                                             ";
			writer.write("HCP"+generaDomiciliacionPagos.getClabeInstitBancaria()
			+generaDomiciliacionPagos.getFechaArchivo()
			+generaDomiciliacionPagos.getConsecutivo()
			+Utileria.completaCerosIzquierda(generaDomiciliacionPagosBean.size(), 6)
			+Utileria.completaCerosIzquierda(importeTotal, 15)
			+Utileria.completaCerosIzquierda(generaDomiciliacionPagosBean.size(), 6)
			+Utileria.completaCerosIzquierda(importeTotal, 15)
			+Utileria.completaCerosIzquierda("0", 6)
			+Utileria.completaCerosIzquierda("0", 15)
			+Utileria.completaCerosIzquierda("0", 6)
			+"0"
			+espacios);

			GeneraDomiciliacionPagosBean detalle = null;

			for(int i = 0;i<generaDomiciliacionPagosBean.size();i++){
				detalle = new GeneraDomiciliacionPagosBean();

				detalle = (GeneraDomiciliacionPagosBean)generaDomiciliacionPagosBean.get(i);

				writer.newLine();
				String montoExigible = detalle.getMontoExigible().replace(".", "");
				writer.write("D"+generaDomiciliacionPagos.getFechaArchivo()
				+Utileria.completaCerosIzquierda(detalle.getNumEmpleado(), 10)
				+agregaEspacio(detalle.getReferencia(),40,'D')
				+Utileria.completaCerosIzquierda(detalle.getCreditoID(), 12)+agregaEspacio(detalle.getDescripcion(),28,'D')
				+Utileria.completaCerosIzquierda(montoExigible, 15)
				+detalle.getCuentaClabe().substring(0,3)
				+"40"
				+Utileria.completaCerosIzquierda(detalle.getCuentaClabe(), 18)
				+"1"
				+"A"
				+"00000000"
				+agregaEspacio("",18,'D'));
			}

			writer.newLine();
			writer.close();


			FileInputStream archivoAfiliacion = new FileInputStream(nombreArchivo);
			int longitud = archivoAfiliacion.available();
			byte[] datos = new byte[longitud];
			archivoAfiliacion.read(datos);
			archivoAfiliacion.close();

			response.setHeader("Content-Disposition","attachment;filename="+nombreArchivo);
			response.setContentType("application/text");
			ouputStream = response.getOutputStream();
			ouputStream.write(datos);
			ouputStream.flush();
			ouputStream.close();

		}catch(Exception e){
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"- Error en generar la Domiciliación de Pagos", e);
		}
	}

	/**
	 *
	 * @param rutaDirectorio: Creación de Directorios para alojar el Layout de Domiciliación de Pagos de Nómina.
	 */
	public void crearDirectorio(String rutaDirectorio){
		File rutaNomina = new File(rutaDirectorio);
		try{
		if(!rutaNomina.exists()){
			rutaNomina.mkdirs();
		}
		}catch(Exception e){
			System.err.println("crearDirectorio"+"-"+"error en la creacion del Directorio "+ e);
		}
	}

	/**
	 * Creación de espacios
	 */
	public String agregaEspacio(String cadena,int longitud,char direccion){
		String cadenaNueva = cadena;

		longitud = longitud-cadena.length();
			if(direccion == 'I'){

				for(int i=0; i<longitud;i++){
					cadenaNueva = " "+cadenaNueva;
				}
			}
			if(direccion =='D'){
				for(int i=0; i<longitud;i++){
					cadenaNueva = cadenaNueva+" ";
				}
			}
		return cadenaNueva;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoBaja : Baja de Detalles de Domiciliación de Pagos
	 * @return
	 */
	public MensajeTransaccionBean bajaDomiciliacionPagos(final GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, final int tipoBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call DOMICILIACIONPAGOSBAJ(?,?,?,		?,?,?,	 ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_ConsecutivoID",Utileria.convierteLong(generaDomiciliacionPagosBean.getConsecutivoID()));
							sentenciaStore.setLong("Par_NumTransaccion",Utileria.convierteLong(generaDomiciliacionPagosBean.getNumTransaccion()));
							sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

							//Parametros de OutPut
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

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
					loggerSAFI.error(this.getClass()+" - "+"Error en dar de Baja la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoBaja : Eliminación de Domiciliación de Pagos
	 * @return
	 */
	public MensajeTransaccionBean eliminaDomiciliacionPagos(final GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, final int tipoBaja) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call DOMICILIACIONPAGOSBAJ(?,?,?,		?,?,?,	 ?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_ConsecutivoID",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Par_NumTransaccion",Utileria.convierteLong(generaDomiciliacionPagosBean.getNumTransaccion()));
							sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

							//Parametros de OutPut
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

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
					loggerSAFI.error(this.getClass()+" - "+"Error en eliminar la Domiciliación de Pagos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 *
	 * @param tipoConsulta : Consulta de Clientes para Domiciliación de Pagos
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public GeneraDomiciliacionPagosBean consultaClientes(int tipoConsulta,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
		GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									generaDomiciliacionPagosBean.getEsNomina(),
									Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
									Utileria.convierteEntero(generaDomiciliacionPagosBean.getConvenioNominaID()),
									Utileria.convierteEntero(generaDomiciliacionPagosBean.getClienteID()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraDomiciliacionPagosDAO.consultaClientes",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
					generaDomiciliacionPagos.setClienteID(Utileria.completaCerosIzquierda(
    						resultSet.getString("ClienteID"),GeneraDomiciliacionPagosBean.LONGITUD_ID));
					generaDomiciliacionPagos.setNombreCliente(resultSet.getString("NombreCompleto"));
					return generaDomiciliacionPagos;
				}
			});

			generaDomiciliacionPagos= matches.size() > 0 ? (GeneraDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Clientes para la Domiciliación de Pagos", e);
		}
		return generaDomiciliacionPagos;
	}

	/**
	 *
	 * @param tipoConsulta : Consulta de Información Domiciliación de Pagos por Folio
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public GeneraDomiciliacionPagosBean consultaFolio(int tipoConsulta,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
		GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Utileria.convierteLong(generaDomiciliacionPagosBean.getFolioID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraDomiciliacionPagosDAO.consultaFolio",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
					generaDomiciliacionPagos.setFolioID(resultSet.getString("FolioID"));
					generaDomiciliacionPagos.setNumTransaccion(resultSet.getString("NumTransaccion"));
					return generaDomiciliacionPagos;
				}
			});

			generaDomiciliacionPagos= matches.size() > 0 ? (GeneraDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Folio para la Domiciliación de Pagos", e);
		}
		return generaDomiciliacionPagos;
	}


	public GeneraDomiciliacionPagosBean consultaFolioDomicilia(int tipoConsulta,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
		GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Utileria.convierteLong(generaDomiciliacionPagosBean.getFolioID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraDomiciliacionPagosDAO.consultaFolio",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
					generaDomiciliacionPagos.setFolioID(resultSet.getString("FolioID"));
					return generaDomiciliacionPagos;
				}
			});

			generaDomiciliacionPagos= matches.size() > 0 ? (GeneraDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Folio para la Domiciliación de Pagos", e);
		}
		return generaDomiciliacionPagos;
	}




	/**
	 *
	 * @param tipoConsulta : Consulta Domiciliacion de Pagos de Convenios de Nomina
	 * @param generaDomiciliacionPagosBean
	 * @return
	 */
	public GeneraDomiciliacionPagosBean consultaDomiciliaPagos(int tipoConsulta,GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean) {
		GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									Constantes.STRING_VACIO,
									Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
									Utileria.convierteEntero(generaDomiciliacionPagosBean.getConvenioNominaID()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraDomiciliacionPagosDAO.consultaDomicilia",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
					generaDomiciliacionPagos.setDomiciliacionPagos(resultSet.getString("DomiciliacionPagos"));
					return generaDomiciliacionPagos;
				}
			});

			generaDomiciliacionPagos= matches.size() > 0 ? (GeneraDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Folio para la Domiciliación de Pagos", e);
		}
		return generaDomiciliacionPagos;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoConsulta : Consulta de Parámetros para generar el Layout de Domiciliación de Pagos
	 * @return
	 */
	public GeneraDomiciliacionPagosBean consultaParametrosArchivo(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean,int tipoConsulta) {
		GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
		try{
			//Query con el Store Procedure
			String query = "call DOMICILIACIONPAGOSCON(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?);";

			Object[] parametros = {
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Utileria.convierteLong(generaDomiciliacionPagosBean.getConsecutivoID()),
									tipoConsulta,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"GeneraDomiciliacionPagosDAO.consultaParam",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSCON(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
					generaDomiciliacionPagos.setClabeInstitBancaria(resultSet.getString("Var_ClabeInstitBancaria"));
					generaDomiciliacionPagos.setNombreArchivo(resultSet.getString("NombreArchivo"));
					generaDomiciliacionPagos.setFechaArchivo(resultSet.getString("Var_FechaArchivo"));
					generaDomiciliacionPagos.setConsecutivo(resultSet.getString("Consecutivo"));
					generaDomiciliacionPagos.setImporteTotal(resultSet.getString("ImporteTotal"));

					return generaDomiciliacionPagos;
				}
			});

			generaDomiciliacionPagos= matches.size() > 0 ? (GeneraDomiciliacionPagosBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de Parámetros para generar el Layout de Domiciliación de Pagos", e);
		}
		return generaDomiciliacionPagos;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoLista : Lista de Clientes para Domiciliación de Pagos
	 * @return
	 */
	public List listaClientes(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, int tipoLista) {
		List listaClientes=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								generaDomiciliacionPagosBean.getEsNomina(),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getConvenioNominaID()),
								Constantes.ENTERO_CERO,
								generaDomiciliacionPagosBean.getNombreCliente(),

								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaClientes",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();

				generaDomiciliacionPagos.setClienteID(resultSet.getString("ClienteID"));
				generaDomiciliacionPagos.setNombreCliente(resultSet.getString("NombreCompleto"));


				return generaDomiciliacionPagos;
			}
		});

		listaClientes= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Clientes para la Domiciliación de Pagos", e);
		}
		return listaClientes;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoLista : Lista de Domiciliación de Pagos
	 * @return
	 */
	public List listaDomiciliacionPagos(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, int tipoLista) {
		List listaDomiciliacion=null;
		transaccionDAO.generaNumeroTransaccion();
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								generaDomiciliacionPagosBean.getEsNomina(),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getConvenioNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getClienteID()),
								Constantes.STRING_VACIO,

								generaDomiciliacionPagosBean.getFrecuencia(),
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaDomiciliaPagos",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();

				generaDomiciliacionPagos.setConsecutivoID(resultSet.getString("ConsecutivoID"));
				generaDomiciliacionPagos.setClienteID(resultSet.getString("ClienteID"));
				generaDomiciliacionPagos.setNombreCliente(resultSet.getString("NombreCompleto"));
				generaDomiciliacionPagos.setInstitucionID(resultSet.getString("InstitucionID"));
				generaDomiciliacionPagos.setNombreInstitucion(resultSet.getString("NombreInstitucion"));
				generaDomiciliacionPagos.setCuentaClabe(resultSet.getString("CuentaClabe"));
				generaDomiciliacionPagos.setCreditoID(resultSet.getString("CreditoID"));
				generaDomiciliacionPagos.setMontoExigible(resultSet.getString("MontoExigible"));
				generaDomiciliacionPagos.setNumTransaccion(resultSet.getString("NumTransaccion"));
				generaDomiciliacionPagos.setFolioID(resultSet.getString("FolioID"));

				return generaDomiciliacionPagos;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Domiciliación de Pagos", e);
		}
		return listaDomiciliacion;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoLista : Lista de Búqueda de Domiciliación de Pagos Paginadas
	 * @return
	 */
	public List listaDomiciliacionPagosPag(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, int tipoLista) {
		List listaDomiciliacion=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								generaDomiciliacionPagosBean.getEsNomina(),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getConvenioNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getClienteID()),
								Constantes.STRING_VACIO,

								generaDomiciliacionPagosBean.getFrecuencia(),
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								Utileria.convierteLong(generaDomiciliacionPagosBean.getNumTransaccion()),
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaDomiciliaPagos",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();

				generaDomiciliacionPagos.setConsecutivoID(resultSet.getString("ConsecutivoID"));
				generaDomiciliacionPagos.setClienteID(resultSet.getString("ClienteID"));
				generaDomiciliacionPagos.setNombreCliente(resultSet.getString("NombreCompleto"));
				generaDomiciliacionPagos.setInstitucionID(resultSet.getString("InstitucionID"));
				generaDomiciliacionPagos.setNombreInstitucion(resultSet.getString("NombreInstitucion"));
				generaDomiciliacionPagos.setCuentaClabe(resultSet.getString("CuentaClabe"));
				generaDomiciliacionPagos.setCreditoID(resultSet.getString("CreditoID"));
				generaDomiciliacionPagos.setMontoExigible(resultSet.getString("MontoExigible"));
				generaDomiciliacionPagos.setNumTransaccion(resultSet.getString("NumTransaccion"));
				generaDomiciliacionPagos.setFolioID(resultSet.getString("FolioID"));

				return generaDomiciliacionPagos;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Domiciliación de Pagos Paginadas", e);
		}
		return listaDomiciliacion;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoLista : Lista de Búqueda de Domiciliación de Pagos
	 * @return
	 */
	public List listaBusqueda(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, int tipoLista) {
		List listaDomiciliacion=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								generaDomiciliacionPagosBean.getEsNomina(),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getConvenioNominaID()),
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getClienteID()),
								Constantes.STRING_VACIO,

								generaDomiciliacionPagosBean.getFrecuencia(),
								Constantes.ENTERO_CERO,
								generaDomiciliacionPagosBean.getBusqueda(),
								Utileria.convierteLong(generaDomiciliacionPagosBean.getNumTransaccion()),
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaDomiciliaPagos",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();

				generaDomiciliacionPagos.setConsecutivoID(resultSet.getString("ConsecutivoID"));
				generaDomiciliacionPagos.setClienteID(resultSet.getString("ClienteID"));
				generaDomiciliacionPagos.setNombreCliente(resultSet.getString("NombreCompleto"));
				generaDomiciliacionPagos.setInstitucionID(resultSet.getString("InstitucionID"));
				generaDomiciliacionPagos.setNombreInstitucion(resultSet.getString("NombreInstitucion"));
				generaDomiciliacionPagos.setCuentaClabe(resultSet.getString("CuentaClabe"));
				generaDomiciliacionPagos.setCreditoID(resultSet.getString("CreditoID"));
				generaDomiciliacionPagos.setMontoExigible(resultSet.getString("MontoExigible"));
				generaDomiciliacionPagos.setNumTransaccion(resultSet.getString("NumTransaccion"));
				generaDomiciliacionPagos.setFolioID(resultSet.getString("FolioID"));

				return generaDomiciliacionPagos;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Búsqueda de Domiciliación de Pagos", e);
		}
		return listaDomiciliacion;
	}

	/**
	 *
	 * @param folioID : Lista para generar el Layout de Domiciiación de Pagos
	 * @param tipoLista : 6
	 * @return
	 */
	public List listaLayoutDomPagos(String folioID, int tipoLista) {
		List listaDomiciliacion=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,

								Constantes.STRING_VACIO,
								Utileria.convierteLong(folioID),
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaLayout",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();
				generaDomiciliacionPagos.setNumEmpleado(resultSet.getString("NoEmpleado"));
				generaDomiciliacionPagos.setReferencia(resultSet.getString("Referencia"));
				generaDomiciliacionPagos.setCuentaClabe(resultSet.getString("CuentaClabe"));
				generaDomiciliacionPagos.setMontoExigible(resultSet.getString("MontoExigible"));
				generaDomiciliacionPagos.setCreditoID(resultSet.getString("CreditoID"));
				generaDomiciliacionPagos.setDescripcion(resultSet.getString("Descripcion"));

				return generaDomiciliacionPagos;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Layout de Domiciliación de Pagos", e);
		}
		return listaDomiciliacion;
	}

	/**
	 *
	 * @param generaDomiciliacionPagosBean
	 * @param tipoLista : Lista de Convenios de Empresa de Nomina
	 * @return
	 */
	public List listaConveniosNomina(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, int tipoLista) {
		List listaDomiciliacion=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(generaDomiciliacionPagosBean.getInstitNominaID()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,

								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaConvenios",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean listaClientes = new GeneraDomiciliacionPagosBean();

				listaClientes.setConvenioNominaID(resultSet.getString("ConvenioNominaID"));
				listaClientes.setDescripcion(resultSet.getString("Descripcion"));

				return listaClientes;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Convenios de Nómina", e);
		}
		return listaDomiciliacion;
	}



	public List listaFolioDomicilia(GeneraDomiciliacionPagosBean generaDomiciliacionPagosBean, int tipoLista) {
		List listaDomiciliacion=null;
		try{
		String query = "call DOMICILIACIONPAGOSLIS(?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?, ?,?,?);";
		Object[] parametros = {
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,

								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								generaDomiciliacionPagosBean.getBusqueda(),
								Constantes.ENTERO_CERO,
								generaDomiciliacionPagosBean.getFechaArchivo(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"GeneraDomiciliacionPagosDAO.listaFolioDomicilia",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DOMICILIACIONPAGOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				GeneraDomiciliacionPagosBean generaDomiciliacionPagos = new GeneraDomiciliacionPagosBean();

				generaDomiciliacionPagos.setFechaArchivo(resultSet.getString("FechaRegistro"));
				generaDomiciliacionPagos.setFolioID(resultSet.getString("FolioID"));
				generaDomiciliacionPagos.setNombreArchivo(resultSet.getString("NombreArchivo"));


				return generaDomiciliacionPagos;
			}
		});

		listaDomiciliacion= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Búsqueda de Folios de Domiciliación de Pagos", e);
		}
		return listaDomiciliacion;
	}



}