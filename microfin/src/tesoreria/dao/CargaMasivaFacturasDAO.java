package tesoreria.dao;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.web.multipart.MultipartFile;

import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO;
import tesoreria.bean.CargaMasivaFacturasBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CargaMasivaFacturasDAO extends BaseDAO{

	ParamGeneralesDAO paramGeneralesDAO;
	String nombreArchivo = "";

	// Procesa baja de facturas de proveedores "CARGA MASIVA"
		public MensajeTransaccionBean bajaFacturasDetalle(final CargaMasivaFacturasBean cargaMasivaFacturasBean, List<CargaMasivaFacturasBean> listaFactura){
				MensajeTransaccionBean resultado = new MensajeTransaccionBean();
				try{
					for(int iteracion =0; iteracion<listaFactura.size(); iteracion++){
						CargaMasivaFacturasBean facturasBean = (CargaMasivaFacturasBean) listaFactura.get(iteracion);
						facturasBean.setFolioCargaID(cargaMasivaFacturasBean.getFolioCargaID());
						if(facturasBean.getEstatus().equals("S")){
							resultado = bajaFacturasMasivas(facturasBean, 1);
						}
						if(resultado.getNumero() != Constantes.CODIGO_SIN_ERROR){
							return resultado;
						}
					}

				}catch(Exception e){

					if (resultado.getNumero() == 0) {
						resultado.setNumero(999);
						resultado.setDescripcion(e.getMessage());
						resultado.setNombreControl(resultado.getNombreControl());
					}
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar las facturas", e);
				}

				return resultado;

			}


	// Procesa detalle de facturas
	public MensajeTransaccionBean procesaFacturasDetalle(final CargaMasivaFacturasBean cargaMasivaFacturasBean, List<CargaMasivaFacturasBean> listaFactura){
			MensajeTransaccionBean resultado = new MensajeTransaccionBean();
			try{
				for(int iteracion =0; iteracion<listaFactura.size(); iteracion++){
					CargaMasivaFacturasBean facturasBean = (CargaMasivaFacturasBean) listaFactura.get(iteracion);
					facturasBean.setFolioCargaID(cargaMasivaFacturasBean.getFolioCargaID());
					facturasBean.setMes(cargaMasivaFacturasBean.getMes());
					facturasBean.setCentroCostoID(cargaMasivaFacturasBean.getCentroCostoID());
					facturasBean.setTipoGastoID(cargaMasivaFacturasBean.getTipoGastoID());
					if(facturasBean.getEstatus().equals("S")){
						resultado = altaFacturasMasivas(facturasBean, 1);
					}
					if(resultado.getNumero() != Constantes.CODIGO_SIN_ERROR){
						return resultado;
					}
				}

			}catch(Exception e){

				if (resultado.getNumero() == 0) {
					resultado.setNumero(999);
					resultado.setDescripcion(e.getMessage());
					resultado.setNombreControl(resultado.getNombreControl());
				}
				e.printStackTrace();
				loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar las facturas", e);
			}

			return resultado;

		}

	// Carga de detalle de facturas
	public MensajeTransaccionBean altaFacturasDetalle(final CargaMasivaFacturasBean cargaMasivaFacturasBean){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		try{
			//SE GUARDA EL ARCHVIO
			resultado = guardaArchivoCargaMasivaFacturas(cargaMasivaFacturasBean);

			if(resultado.getNumero() != Constantes.CODIGO_SIN_ERROR){
				Utileria.borraArchivo(nombreArchivo);
				return resultado;
			}
			//SE EJECUTA EL ETL
			cargaMasivaFacturasBean.setRutaArchivo(nombreArchivo);
			resultado = procesarETLCargaMasivaFacturas(cargaMasivaFacturasBean);

			if(resultado.getNumero()!=0){
				Utileria.borraArchivo(nombreArchivo);
				loggerSAFI.info(this.getClass()+" - "+"Error al intentar Procesar la carga Masiva de Facturas:  " + resultado.getDescripcion());
				return resultado;
			}

			//PROCESA LA INFORMACION
			resultado = procesarCargaMasivaFacturas(cargaMasivaFacturasBean);

			if(resultado.getNumero()!=0){
				Utileria.borraArchivo(nombreArchivo);
				loggerSAFI.info(this.getClass()+" - "+"Error al intentar Procesar la carga masiva de facturas :  " + resultado.getDescripcion());
				throw new Exception(resultado.getDescripcion());
			}

			String[] auxiliares = resultado.getCampoGenerico().split("-");
			int total = Integer.parseInt(auxiliares[0]);
			int totalExito = Integer.parseInt(auxiliares[1]);
			int totalError = Integer.parseInt(auxiliares[2]);

			resultado.setDescripcion ("" +
					"<table border='0'>" +
					"<tr>" +
					"<td>Folio Carga: </td>" +
					"<td style='text-align:right;'>"+ resultado.getConsecutivoInt()+"</td>" +
					"</tr>" +
					"<tr>" +
					"<td>Registro Total: </td>" +
					"<td style='text-align:right;'>"+total+"</td>" +
					"</tr>" +
					"<tr>" +
					"<td>Registros Exitosos: </td>" +
					"<td style='text-align:right;'>"+totalExito+"</td>" +
					"</tr>" +
					"<tr>" +
					"<td>Registros Fallidos: </td>" +
					"<td style='text-align:right;'>"+totalError+"</td>" +
					"</tr>" +
					"</table>" +
					"");

		}catch(Exception e){

			if (resultado.getNumero() == 0) {
				resultado.setNumero(999);
				resultado.setDescripcion(e.getMessage());
				resultado.setNombreControl(resultado.getNombreControl());
			}
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga masiva de facturas", e);
		}

		return resultado;

	}


	//Guardar fisicamente el archivo de carga masiva de facturas en el directorio
	public MensajeTransaccionBean guardaArchivoCargaMasivaFacturas(CargaMasivaFacturasBean cargaMasivaFacturasBean){

		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		String directorio = "";
		boolean creado = false;

		//Validamos que exista un archivo
		String archivo = cargaMasivaFacturasBean.getFile().getOriginalFilename();
		if (archivo == null || archivo=="") {
			resultado.setNumero(1);
			resultado.setDescripcion("Porfavor Especifique el Archivo.");
			return resultado;
		}
		ParamGeneralesBean paramGeneralesBeanRespuesta = paramGeneralesDAO.consultaPrincipal(new ParamGeneralesBean(),ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaArchivoCargaFacturas);
		if (paramGeneralesBeanRespuesta == null || paramGeneralesBeanRespuesta.equals("")) {
			resultado.setNumero(2);
			resultado.setDescripcion("Configure la ruta de Archivos para la Carga de Facturas");
			return resultado;
		}

		directorio = paramGeneralesBeanRespuesta.getValorParametro();
		Date f = new Date();
		SimpleDateFormat formatoFecha = new SimpleDateFormat("dd-MM-yyyyhh:mm:ss");
		String fecha = formatoFecha.format(f);
		try{
			creado = (new File(directorio)).exists();
			if(!creado) {
				File aDir = new File(directorio);
				aDir.mkdir();
			}

			MultipartFile file = cargaMasivaFacturasBean.getFile();
			nombreArchivo = directorio+fecha+".xls";
			File filespring = new File(nombreArchivo);
			FileUtils.writeByteArrayToFile(filespring, file.getBytes());
		}catch(Exception e){

		}

		resultado.setNumero(Constantes.CODIGO_SIN_ERROR);
		resultado.setDescripcion("Archivo guardado exitosamente");

		return resultado;
	}

	public MensajeTransaccionBean procesarETLCargaMasivaFacturas(CargaMasivaFacturasBean cargaMasivaFacturasBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try{
			ParamGeneralesBean paramGeneralesBean = paramGeneralesDAO.consultaPrincipal(new ParamGeneralesBean(),ParamGeneralesDAO.Enum_Con_ParamGenerales.RutaEjecutableCargaFacturas);

			if (paramGeneralesBean == null || paramGeneralesBean.equals("")) {
				mensaje.setNumero(2);
				mensaje.setDescripcion("Configure la ruta de Archivos para el Procesamiento de las Facturas");
				return mensaje;
			}

			String rutaAplicacionesFacturas = paramGeneralesBean.getValorParametro();
			File directorioETL = new File(rutaAplicacionesFacturas);
			loggerSAFI.info(this.getClass()+" - "+"Ruta ejecutables carga Facturas: "+directorioETL);
			if (!directorioETL.exists()) {
				loggerSAFI.info(this.getClass()+" - "+"Configure la Carpeta donde se encuentran los Ejecutables para la Carga Masiva de Facturas.");
				throw new Exception("Configure la Carpeta donde se encuentran los Ejecutables para la Carga Masiva de Facturas.<br><br> ["+directorioETL+"]");
			}

			String shProcesa = rutaAplicacionesFacturas+"CargaMasivaFacturas.sh";
			loggerSAFI.info(this.getClass()+" - "+"Ruta sh carga Facturas: "+shProcesa);
			File archivoSH = new File(shProcesa);
			if(!archivoSH.exists()) {
				loggerSAFI.info(this.getClass()+" - "+"No se encontro el ejecutable para la Carga Masiva de Facturas.");
				throw new Exception("No se encontro el ejecutable para la Carga Masiva de Facturas.");
			}

			loggerSAFI.info(this.getClass()
					+"\n Datos [\n"
					+"\n		"+cargaMasivaFacturasBean.getRutaArchivo()
					+"\n		"+cargaMasivaFacturasBean.getFechaCarga()
					+"\n		"+cargaMasivaFacturasBean.getMes()
					+"\n]");

			String[] command = {"sh", shProcesa, cargaMasivaFacturasBean.getRutaArchivo(),cargaMasivaFacturasBean.getFechaCarga(), cargaMasivaFacturasBean.getMes(),};
			ProcessBuilder pb = new ProcessBuilder();
			pb.command(command);
			loggerSAFI.info(this.getClass()+" - "+"Inicio Ejecucion ETL por SH");
			Process p = pb.start();
			p.waitFor();
			loggerSAFI.info(this.getClass()+" - "+"Fin Ejecucion ETL por SH");
			//Leemos salida del programa
			InputStream is = p.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;
			String respuesta = null;
			while ((line = br.readLine()) != null) {
				respuesta = line;
			}

			String[] partes = respuesta.split("-");
			int codigoRespuesta = Integer.parseInt(partes[0]);
			String mensajeRespuesta = partes[1];
			loggerSAFI.info(this.getClass()+" - "+"Respuesta recibida del SH:" + respuesta);

			mensaje.setNumero(codigoRespuesta);
			mensaje.setDescripcion(mensajeRespuesta);

		}catch(Exception e){
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error al procesar el archivo de Carga Masiva de Facturas en SH" + e);
			e.printStackTrace();
			if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}

	/*PROCESA LOS REGISTROS DE LA CARGA MASIVA DE FACTURAS */
	public MensajeTransaccionBean procesarCargaMasivaFacturas(final CargaMasivaFacturasBean cargaMasivaFacturasBean) {
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

								String query = "call TMPCARGAFACTURASPRO(?,?,?,?,?,				" +
																		"?,?,?,?,?,				" +
																		"?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_RutaArchivo",cargaMasivaFacturasBean.getRutaArchivo());
								//sentenciaStore.registerOutParameter("Par_ActivoID", Types.INTEGER);
								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
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
							public Object doInCallableStatement(CallableStatement callableStatement)
									throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString("campoGenerico"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.procesarCargaMasivaFacturas");
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
						throw new Exception(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.procesarCargaMasivaFacturas");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"procesarCargaMasivaFacturas-Error al procesar carga masiva de factuas" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error ");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Lista fallidas de la carga de facturas masivas
	public List listaFacturaFallidas(final int tipoLista, CargaMasivaFacturasBean cargaMasivaFacturasBean){
		String query = "call BITACORACARGAFACTLIS(?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CargaMasivaFacturasDAO.listaFacturaFallidas",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORACARGAFACTLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CargaMasivaFacturasBean bitacoraBean = new CargaMasivaFacturasBean();
				bitacoraBean.setConsecutivo(resultSet.getString("Consecutivo"));
				bitacoraBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				bitacoraBean.setUUID(resultSet.getString("UUID"));
				bitacoraBean.setRfcEmisor(resultSet.getString("RfcEmisor"));
				bitacoraBean.setNombreEmisor(resultSet.getString("NombreEmisor"));
				bitacoraBean.setSubTotal(resultSet.getString("SubTotal"));
				bitacoraBean.setDescuento(resultSet.getString("Descuento"));
				bitacoraBean.setTotal(resultSet.getString("Total"));
				bitacoraBean.setDescripcionError(resultSet.getString("DescripcionError"));

				return bitacoraBean;
			}
		});
		return matches;
	}

	// Lista exitosa de la carga de facturas masivas
	public List listaFacturaExitosas(final int tipoLista, CargaMasivaFacturasBean cargaMasivaFacturasBean){
		String query = "call BITACORACARGAFACTLIS(?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CargaMasivaFacturasDAO.listaFacturaExitosas",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORACARGAFACTLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CargaMasivaFacturasBean bitacoraBean = new CargaMasivaFacturasBean();
				bitacoraBean.setConsecutivo(resultSet.getString("Consecutivo"));
				bitacoraBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				bitacoraBean.setUUID(resultSet.getString("UUID"));
				bitacoraBean.setRfcEmisor(resultSet.getString("RfcEmisor"));
				bitacoraBean.setNombreEmisor(resultSet.getString("NombreEmisor"));
				bitacoraBean.setSubTotal(resultSet.getString("SubTotal"));
				bitacoraBean.setDescuento(resultSet.getString("Descuento"));
				bitacoraBean.setTotal(resultSet.getString("Total"));
				bitacoraBean.setDescripcionError(resultSet.getString("DescripcionError"));
				bitacoraBean.setFechaEmision(resultSet.getString("FechaEmision"));
				bitacoraBean.setFolioFacturaID(resultSet.getString("FolioFacturaID"));
				bitacoraBean.setSeleccionadoCheck(resultSet.getString("SeleccionadoCheck"));
				bitacoraBean.setEstatus(resultSet.getString("EstatusCheck"));
				bitacoraBean.setFolio(resultSet.getString("Folio"));
				bitacoraBean.setSafiID(resultSet.getString("SafiID"));


				return bitacoraBean;
			}
		});
		return matches;
	}

	// Lista de ayuda de folio de carga
	public List listaAyudaFolio(final int tipoLista, CargaMasivaFacturasBean cargaMasivaFacturasBean){
		String query = "call ARCHIVOSCARGAFACTLIS(?,?,?,?,?," +
												 "?,?,?,?);";
		Object[] parametros = {
				cargaMasivaFacturasBean.getDescripcion(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CargaMasivaFacturasDAO.listaAyudaFolio",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVOSCARGAFACTLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CargaMasivaFacturasBean cargaMasivaFacturasBean = new CargaMasivaFacturasBean();
				cargaMasivaFacturasBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				cargaMasivaFacturasBean.setUsuario(resultSet.getString("Usuario"));
				cargaMasivaFacturasBean.setFechaCarga(resultSet.getString("FechaCarga"));
				return cargaMasivaFacturasBean;
			}
		});
		return matches;
	}

	/* Consulta principal*/
	public CargaMasivaFacturasBean consultaPrincipal(int tipoConsulta, CargaMasivaFacturasBean cargaMasivaFacturasBean) {
		CargaMasivaFacturasBean cargaMasiva = null;
        try{
            //Query con el Store Procedure
            String query = "call ARCHIVOSCARGAFACTCON(?,?,?,?,?,			" +
            										 "?,?,?,?				);";
            Object[] parametros = {	Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()),
                                    tipoConsulta,
                                    Constantes.ENTERO_CERO,
                                    Constantes.ENTERO_CERO,
                                    Constantes.FECHA_VACIA,
                                    Constantes.STRING_VACIO,
                                    "CargaMasivaFacturasDAO.consultaPrincipal",
                                    Constantes.ENTERO_CERO,
                                    Constantes.ENTERO_CERO
                                };
            loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVOSCARGAFACTCON(" + Arrays.toString(parametros) + ")");


            List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
                public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                	CargaMasivaFacturasBean cargaMasivaFacturas = new CargaMasivaFacturasBean();
                                //personas morales
                	cargaMasivaFacturas.setFolioCargaID(resultSet.getString("FolioCargaID"));
                	cargaMasivaFacturas.setMes(resultSet.getString("Mes"));
                	cargaMasivaFacturas.setUsuario(resultSet.getString("Usuario"));
                	cargaMasivaFacturas.setFechaCarga(resultSet.getString("FechaCarga"));
                	cargaMasivaFacturas.setTotalFacturas(resultSet.getString("TotalFacturas"));
                	cargaMasivaFacturas.setNumFacturasExito(resultSet.getString("NumFacturasExito"));
                	cargaMasivaFacturas.setNumFacturasError(resultSet.getString("NumFacturasError"));
                	cargaMasivaFacturas.setNumFacturasError(resultSet.getString("NumFacturasError"));
                	cargaMasivaFacturas.setEstatus(resultSet.getString("Estatus"));
                	cargaMasivaFacturas.setDescripcionEstatus(resultSet.getString("DescripcionEstatus"));
                    return cargaMasivaFacturas;

                }
            });
            cargaMasiva= matches.size() > 0 ? (CargaMasivaFacturasBean) matches.get(0) : null;
        }catch(Exception e){

            e.printStackTrace();
            loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

        }
        return cargaMasiva;
      }
	/* Consulta de detalle del folio*/
	public CargaMasivaFacturasBean consultaDetalleFolio(int tipoConsulta, CargaMasivaFacturasBean cargaMasivaFacturasBean) {
		CargaMasivaFacturasBean cargaMasiva = null;
        try{
            //Query con el Store Procedure
            String query = "call ARCHIVOSCARGAFACTCON(?,?,?,?,?,			" +
            										 "?,?,?,?				);";
            Object[] parametros = {	Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()),
                                    tipoConsulta,
                                    Constantes.ENTERO_CERO,
                                    Constantes.ENTERO_CERO,
                                    Constantes.FECHA_VACIA,
                                    Constantes.STRING_VACIO,
                                    "CargaMasivaFacturasDAO.consultaPrincipal",
                                    Constantes.ENTERO_CERO,
                                    Constantes.ENTERO_CERO
                                };
            loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARCHIVOSCARGAFACTCON(" + Arrays.toString(parametros) + ")");


            List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
                public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
                	CargaMasivaFacturasBean cargaMasivaFacturas = new CargaMasivaFacturasBean();
                                //personas morales
                	cargaMasivaFacturas.setFolioCargaID(resultSet.getString("FolioCargaID"));
                	cargaMasivaFacturas.setMes(resultSet.getString("Mes"));
                	cargaMasivaFacturas.setUsuario(resultSet.getString("Usuario"));
                	cargaMasivaFacturas.setFechaCarga(resultSet.getString("FechaCarga"));
                	cargaMasivaFacturas.setTotalFacturas(resultSet.getString("TotalFacturas"));
                	cargaMasivaFacturas.setNumFacturasExito(resultSet.getString("NumFacturasExito"));
                	cargaMasivaFacturas.setNumFacturasError(resultSet.getString("NumFacturasError"));
                	cargaMasivaFacturas.setNumFacturasError(resultSet.getString("NumFacturasError"));
                	cargaMasivaFacturas.setEstatus(resultSet.getString("Estatus"));
                	cargaMasivaFacturas.setMesNoCorresponde(resultSet.getString("MesNoCorresponde"));
                	cargaMasivaFacturas.setMesCorresponde(resultSet.getString("MesCorresponde"));
                	cargaMasivaFacturas.setProvNoExiste(resultSet.getString("ProvNoExiste"));
                	cargaMasivaFacturas.setProvExiste(resultSet.getString("ProvExiste"));
                	cargaMasivaFacturas.setTotalProvedores(resultSet.getString("TotalProvedores"));
                    return cargaMasivaFacturas;

                }
            });
            cargaMasiva= matches.size() > 0 ? (CargaMasivaFacturasBean) matches.get(0) : null;
        }catch(Exception e){

            e.printStackTrace();
            loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de clientes", e);

        }
        return cargaMasiva;
      }




	/*PROCESA LOS REGISTROS DE LA CARGA MASIVA DE FACTURAS */
	public MensajeTransaccionBean altaFacturasMasivas(final CargaMasivaFacturasBean cargaMasivaFacturasBean, final int TipoTransaccion) {
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

								String query = "call  FACTURASMASIVASPROVPRO(?,?,?,?,?,				" +
																			"?,?,?,?,?,				" +
																			"?,?,?,?,?," +
																			"?						);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()));
								sentenciaStore.setInt("Par_FolioFacturaID",Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioFacturaID()));
								sentenciaStore.setInt("Par_Mes",Utileria.convierteEntero(cargaMasivaFacturasBean.getMes()));
								sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(cargaMasivaFacturasBean.getCentroCostoID()));
								sentenciaStore.setInt("Par_TipoGastoID",Utileria.convierteEntero(cargaMasivaFacturasBean.getTipoGastoID()));
								sentenciaStore.setInt("Par_TipoTransaccion",TipoTransaccion);
								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
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
							public Object doInCallableStatement(CallableStatement callableStatement)
									throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.altaFacturasMaivas");
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
						throw new Exception(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.altaFacturasMaivas");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"altaFacturasMaivas-Error al dar de alta las facturas masivas" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error ");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*ALTA PROVEEDORES DE LA CARGA MASIVA DE FACTURAS */
	public MensajeTransaccionBean altaProvFacturasMasivas(final CargaMasivaFacturasBean cargaMasivaFacturasBean) {
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

								String query = "call  PROVEEDORESMASIVOSPRO(?,?,?,?,?,				" +
																			"?,?,?,?,?,				" +
																			"?						);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()));
								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
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
							public Object doInCallableStatement(CallableStatement callableStatement)
									throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Exito"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Fallidos"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.altaProvFacturasMasivas");
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
						throw new Exception(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.altaProvFacturasMasivas");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"altaProvFacturasMasivas-Error al dar de alta los proveedores masivos" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error ");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Lista proveedores de la carga masiva
	public List listaProveedoresCargaMasiva(final int tipoLista, CargaMasivaFacturasBean cargaMasivaFacturasBean){
		String query = "call BITACORACARGAFACTREP(?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CargaMasivaFacturasDAO.listaProveedoresCargaMasiva",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BITACORACARGAFACTLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CargaMasivaFacturasBean bitacoraBean = new CargaMasivaFacturasBean();
				bitacoraBean.setSafiID(resultSet.getString("SafiID"));
				bitacoraBean.setRfcEmisor(resultSet.getString("RfcEmisor"));
				bitacoraBean.setNombreEmisor(resultSet.getString("NombreCompleto"));
				bitacoraBean.setDescripcionError(resultSet.getString("DescripcionError"));


				bitacoraBean.setFolioCargaID(resultSet.getString("FolioCargaID"));
				bitacoraBean.setFechaCarga(resultSet.getString("FechaCarga"));
				bitacoraBean.setUUID(resultSet.getString("UUID"));
				bitacoraBean.setMesSubirFact(resultSet.getString("MesSubirFact"));
				bitacoraBean.setAnio(resultSet.getString("Anio"));
				bitacoraBean.setMes(resultSet.getString("Mes"));
				bitacoraBean.setDia(resultSet.getString("Dia"));
				bitacoraBean.setFolio(resultSet.getString("NumFactura"));


				return bitacoraBean;
			}
		});
		return matches;
	}

	/*BAJA FACTURA DE LA CARGA MASIVA */
	public MensajeTransaccionBean bajaFacturasMasivas(final CargaMasivaFacturasBean cargaMasivaFacturasBean, final int TipoActualizacionn) {
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

								String query = "call  BITACORACARGAFACTACT(?,?,?,?,?,			" +
																		  "?,?,?,?,?,			" +
																		  "?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_FolioCargaID",Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioCargaID()));
								sentenciaStore.setInt("Par_FolioFacturaID",Utileria.convierteEntero(cargaMasivaFacturasBean.getFolioFacturaID()));
								sentenciaStore.setInt("Par_TipoActualizacion",TipoActualizacionn);
								//Parametros de Salida
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
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
							public Object doInCallableStatement(CallableStatement callableStatement)
									throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.altaFacturasMaivas");
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
						throw new Exception(Constantes.MSG_ERROR + " .CargaMasivaFacturasDAO.altaFacturasMaivas");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"altaFacturasMaivas-Error al dar de alta las facturas masivas" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("Error ");
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public ParamGeneralesDAO getParamGeneralesDAO() {
		return paramGeneralesDAO;
	}


	public void setParamGeneralesDAO(ParamGeneralesDAO paramGeneralesDAO) {
		this.paramGeneralesDAO = paramGeneralesDAO;
	}



}
