package tesoreria.dao;
import org.hibernate.criterion.NaturalIdentifier;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import cuentas.bean.CuentasAhoBean;
import tesoreria.bean.ResultadoCargaArchivosTesoreriaBean;
import tesoreria.bean.TesoMovsArchConciliaBean;
import tesoreria.bean.TesoMovsConciliaBean;
import tesoreria.servicio.TesoMovsConciliaServicio.Enum_VersionArchivo;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class TesoMovsConciliaDAO extends BaseDAO{

	String cargo = "C";
	String abono = "A";
	String saltoLinea=" <br> ";
	PolizaDAO polizaDAO = new PolizaDAO();
	String conceptoConManualID = "75"; // numero de concepto contable para la conciliacion Manual
	String conceptoConManualDes = "CONCILIACION BANCARIA MANUAL"; // descripcion para el concepto contable de conciliacion manual
	String conceptoConManualDesI;
	String automatico = "A"; // indica que se trata de una poliza automatica


	public TesoMovsConciliaDAO(){
		super();
	}

	// funcion para dar de alta movimientos de conciliacion
		public ResultadoCargaArchivosTesoreriaBean altaTesoMovsConc(final TesoMovsArchConciliaBean tesoMovsConBean,
				final TesoMovsArchConciliaBean tesoConcilia,
				final long transaccion){
			ResultadoCargaArchivosTesoreriaBean resultCarga = new ResultadoCargaArchivosTesoreriaBean();
			final ResultadoCargaArchivosTesoreriaBean result = new ResultadoCargaArchivosTesoreriaBean();
			resultCarga = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					try {
						String query = "call TESOMOVSCONCILIAALT(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
						Object[] parametros = {


								Utileria.convierteLong(tesoMovsConBean.getCuentaAhoID()),
								Utileria.convierteEntero(tesoMovsConBean.getInstitucionID()),
								OperacionesFechas.conversionStrDate(tesoMovsConBean.getFechaCarga()),
								tesoConcilia.getFechaOperacion(),
								tesoConcilia.getNatMovimiento(),
								tesoConcilia.getMontoMov(),
								tesoConcilia.getDescripcionMov(),
								tesoMovsConBean.getNumCtaInstit(),
								tesoConcilia.getReferencia(),

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"TesoMovsConciliaDAO.altaTesoMovsConc",
								parametrosAuditoriaBean.getSucursal(),
								transaccion


						};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOMOVSCONCILIAALT(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								ResultadoCargaArchivosTesoreriaBean mensaje = new ResultadoCargaArchivosTesoreriaBean();
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
								mensaje.setExitosos(1);
								mensaje.setFallidos(0);

								return mensaje;
							}
						});
						return matches.size() > 0 ? (ResultadoCargaArchivosTesoreriaBean) matches.get(0) : null;

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de movimiento de conciliacion de tesoreria", e);
						result.setFallidos(1);
						result.setNumero(1);
						result.setDescripcion(e.getCause().toString());
						result.setNombreControl("file");
						result.setExitosos(0);
						transaction.setRollbackOnly();

					}
					return result;
				}
			});
			return resultCarga;
		}



	// proceso para leer y dar de alta movimientos de conciliacion para institucion Banorte
	public ResultadoCargaArchivosTesoreriaBean cargaArchTesoMovsConcBanorte(final TesoMovsArchConciliaBean tesoConcilia,
			final String rutaArchivo){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				//Declaracion de Variables
				ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();	// bean para manejo de errores y resultados
				List<TesoMovsArchConciliaBean> listConcilia = null;		// lista de beans para obtener la lista de conciliaciones del archivo.
				Iterator<TesoMovsArchConciliaBean> iterList=null;		// iterador para el manejo de la lista
				TesoMovsArchConciliaBean concilia=null;					// apuntador para cada bean que devuelva la consulta de la lista
				BufferedReader bufferedReader=null;						// lee el archivo hasta el salto de linea
				String nombreOri	=rutaArchivo;						// Se almacena el en nombre de la ruta de origen
				String tokens[]		=nombreOri.split("[.]");			// Arreglo para separar los el nombre del archivo con su extension
				String extension	="."+tokens[1];						// Se almacena el nombre de la extension
				String motivo		="";								// descripcion de los fallos
				int tamanoLista		=0;									// tamaño de la lista (listConcilia)
				int contador		=1;									// es el contador que representa las lineas de los registros
				int exitos			=0;									// contador de exitos
				int fallidos		=0;									// contador de fallos
				long transaccion	= 0;								// transaccion de la operacion actual, que seria de la carga de archivo
				String motivoexcluido = "";								//

				try {
					switch (Utileria.convierteEntero(tesoConcilia.getVersionFormato())) {
					case Enum_VersionArchivo.Anterior:
						listConcilia = leeArchivoTesoMovsConcBanorte(rutaArchivo);
						break;
					case Enum_VersionArchivo.Actual:
						listConcilia = leeFormatoActualBanorte(rutaArchivo);
						break;
					default:
						listConcilia = null;
						break;
					}

					if(listConcilia!=null){
						iterList=listConcilia.iterator();
						transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
						// while para recorrer el arreglo de beans que se creo al leer el archivo
						while(iterList.hasNext()){
							contador = contador+1;
							concilia=(TesoMovsArchConciliaBean) iterList.next();
							tamanoLista = concilia.getTamanioListaCarga();
							if(concilia.getCuentaAhoID()!=null){
								if(concilia.getCuentaAhoID().equals("123")){
									fallidos = fallidos+1;
									motivo= concilia.getDescripcionMov();
									resultadoBean.setNumero(123);
									resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "
											+tamanoLista +saltoLinea+ motivo);
									throw new Exception(resultadoBean.getDescripcion());
								}
							}else{
										// se valida que el movimiento sea de la misma fecha de carga: que este entre fechas
								Date fechaInicial;
								Date fechaFinal;
								Date fechaConcilia;
								fechaInicial = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaInicial());
								fechaFinal = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaFinal());
								fechaConcilia = OperacionesFechas.conversionStrDate(concilia.getFechaOperacion());
								if( fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal) )
								{
									resultadoBean= altaTesoMovsConc(tesoConcilia, concilia, transaccion);
									exitos = exitos+resultadoBean.getExitosos();
									fallidos = fallidos+resultadoBean.getFallidos();
									if(resultadoBean.getFallidos()>0){
										exitos = 0;
										fallidos = tamanoLista;
										resultadoBean.setNumero(999);
										resultadoBean.setDescripcion(resultadoBean.getDescripcion()+saltoLinea+"Intente cargar de nuevo el archivo.");
										throw new Exception(resultadoBean.getDescripcion());
									}
									else{
										resultadoBean.setExitosos(exitos);
										resultadoBean.setFallidos(fallidos);
										resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido);
									}
								}else{
									motivoexcluido = saltoLinea+ "Motivo Exclusión: La fecha de los movimientos no coincide con el rango de fechas de carga.";
									fallidos += 1;
									resultadoBean.setExitosos(exitos);
									resultadoBean.setFallidos(fallidos);
									resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido);
								}
							}
						}
					}else{
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Error al Cargar, Asegúrese de seleccionar el formato del archivo correctamente.");
						throw new Exception(resultadoBean.getDescripcion());
					}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo de conciliacion de movimiento de tesoreria", e);
					switch(resultadoBean.getNumero()){
					case 123:
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(resultadoBean.getDescripcion());
						break;
					default:
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "+
								tamanoLista +saltoLinea+ "Error en línea: "+ contador+saltoLinea+" Motivo: "+resultadoBean.getDescripcion());
						break;
					}
					transaction.setRollbackOnly();
				}
				return resultadoBean;
			}
		});
		return resultado;
	}

	/**
	 * Proceso para leer y dar de alta los movimiento de conciliación para el banco Banamex.
	 * @param tesoConcilia {@linkplain TesoMovsArchConciliaBean} con los datos de la carga.
	 * @param rutaArchivo Ruta del archivo cargado.
	 * @return {@linkplain ResultadoCargaArchivosTesoreriaBean} con el resultado de la carga.
	 */
	public ResultadoCargaArchivosTesoreriaBean cargaArchivoBanamex(final TesoMovsArchConciliaBean tesoConcilia, final String rutaArchivo){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						//Declaracion de Variables
						ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();	// bean para manejo de errores y resultados
						List<TesoMovsArchConciliaBean> listConcilia = null;		// lista de beans para obtener la lista de conciliaciones del archivo.
						Iterator<TesoMovsArchConciliaBean> iterList=null;		// iterador para el manejo de la lista
						TesoMovsArchConciliaBean concilia=null;					// apuntador para cada bean que devuelva la consulta de la lista
						BufferedReader bufferedReader=null;						// lee el archivo hasta el salto de linea
						String nombreOri	=rutaArchivo;						// Se almacena el en nombre de la ruta de origen
						String tokens[]		=nombreOri.split("[.]");			// Arreglo para separar los el nombre del archivo con su extension
						String extension	="."+tokens[1];						// Se almacena el nombre de la extension
						String motivo		="";								// descripcion de los fallos
						int tamanoLista		=0;									// tamaño de la lista (listConcilia)
						int contador		=1;									// es el contador que representa las lineas de los registros
						int exitos			=0;									// contador de exitos
						int fallidos		=0;									// contador de fallos
						long transaccion	= 0;								// transaccion de la operacion actual, que seria de la carga de archivo
						String motivoexcluido = "";								//

						try {
							switch (Utileria.convierteEntero(tesoConcilia.getVersionFormato())) {
							case Enum_VersionArchivo.Anterior:
							case Enum_VersionArchivo.Actual:
								listConcilia = leeFormatoActualBanamex(rutaArchivo);
								break;
							default:
								listConcilia = null;
								break;
							}

							if(listConcilia!=null){
								iterList=listConcilia.iterator();
								transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
								// while para recorrer el arreglo de beans que se creo al leer el archivo
								while(iterList.hasNext()){
									contador = contador+1;
									concilia=(TesoMovsArchConciliaBean) iterList.next();
									tamanoLista = concilia.getTamanioListaCarga();
									if(concilia.getCuentaAhoID()!=null){
										if(concilia.getCuentaAhoID().equals("123")){
											fallidos = fallidos+1;
											motivo= concilia.getDescripcionMov();
											resultadoBean.setNumero(123);
											resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "
													+tamanoLista +saltoLinea+ motivo);
											throw new Exception(resultadoBean.getDescripcion());
										}
									}else{
										// se valida que el movimiento sea de la misma fecha de carga: que este entre fechas
										Date fechaInicial;
										Date fechaFinal;
										Date fechaConcilia;
										fechaInicial = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaInicial());
										fechaFinal = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaFinal());
										fechaConcilia = OperacionesFechas.conversionStrDate(concilia.getFechaOperacion());
										if( fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal) )
										{
											resultadoBean= altaTesoMovsConc(tesoConcilia, concilia, transaccion);
											exitos = exitos+resultadoBean.getExitosos();
											fallidos = fallidos+resultadoBean.getFallidos();
											if(resultadoBean.getFallidos()>0){
												exitos = 0;
												fallidos = tamanoLista;
												resultadoBean.setNumero(999);
												resultadoBean.setDescripcion(resultadoBean.getDescripcion()+saltoLinea+"Intente cargar de nuevo el archivo.");
												throw new Exception(resultadoBean.getDescripcion());
											}
											else{
												resultadoBean.setExitosos(exitos);
												resultadoBean.setFallidos(fallidos);
												resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido);
											}
										}else{
											motivoexcluido = saltoLinea+ "Motivo Exclusión: La fecha de los movimientos no coincide con el rango de fechas de carga.";
											fallidos += 1;
											resultadoBean.setExitosos(exitos);
											resultadoBean.setFallidos(fallidos);
											resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido);
										}
									}
								}
							}else{
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion("Error al Cargar, Asegúrese de seleccionar el formato del archivo correctamente.");
								throw new Exception(resultadoBean.getDescripcion());
							}

						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en carga de archivo de conciliacion de movimiento de tesoreria", e);
							switch(resultadoBean.getNumero()){
							case 123:
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion(resultadoBean.getDescripcion());
								break;
							default:
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "+
										tamanoLista +saltoLinea+ "Error en línea: "+ contador+saltoLinea+" Motivo: "+resultadoBean.getDescripcion());
								break;
							}
							transaction.setRollbackOnly();
						}
						return resultadoBean;
					}
				});
		return resultado;
	}
	// proceso para leer y dar de alta movimientos de conciliacion para formato Estandar
	public ResultadoCargaArchivosTesoreriaBean cargaArchTesoMovsConcEstandar(final TesoMovsArchConciliaBean tesoConcilia,
			final String rutaArchivo){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				//Declaracion de Variables
				ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();	// bean para manejo de errores y resultados
				List<TesoMovsArchConciliaBean> listConcilia = null;		// lista de beans para obtener la lista de conciliaciones del archivo.
				Iterator<TesoMovsArchConciliaBean> iterList=null;		// iterador para el manejo de la lista
				TesoMovsArchConciliaBean concilia=null;					// apuntador para cada bean que devuelva la consulta de la lista
//				BufferedReader bufferedReader=null;						// lee el archivo hasta el salto de linea
				String nombreOri	=rutaArchivo;						// Se almacena el en nombre de la ruta de origen
				String tokens[]		=nombreOri.split("[.]");			// Arreglo para separar los el nombre del archivo con su extension
				String extension	="."+tokens[1];						// Se almacena el nombre de la extension
				String motivo		="";								// descripcion de los fallos
				String renglon		="";								// renglon actual de la iteracion
				int tamanoLista		=0;									// tamaño de la lista (listConcilia)
				int contador		=1;									// es el contador que representa las lineas de los registros
				int contadorerr		=1;									// contador de errores
				int exitos			=0;									// contador de exitos
				int fallidos		=0;									// contador de fallos
				float cant			=0;									// cantidad del monto de movimiento
				long transaccion	= 0;								// transaccion de la operacion actual, que seria de la carga de archivo
				boolean error		=true;								// bandera de error
				String motivoexcluido = "";								// motivo para excluir registros
				try {

					listConcilia=leeArchivoTesoMovsConcEstandar(rutaArchivo);

					// si la lectura del archivo fue correcta entonces la lista no estara vacia
					if(listConcilia != null){
						iterList=listConcilia.iterator();
						transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
						// while para recorrer el arreglo de beans que se creo al leer el archivo
						while(iterList.hasNext()){
							contador = contador+1;
							concilia=(TesoMovsArchConciliaBean) iterList.next();
							tamanoLista = concilia.getTamanioListaCarga();
							if(concilia.getCuentaAhoID()!=null){
								if(concilia.getCuentaAhoID().equals("123")){
									fallidos = fallidos+1;
									motivo= concilia.getDescripcionMov();
									resultadoBean.setNumero(123);
									resultadoBean.setDescripcion("Total Registros: "+ tamanoLista + saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "
											+tamanoLista +saltoLinea+ motivo);
									throw new Exception(resultadoBean.getDescripcion());
								}
							}else{
								if(Float.parseFloat(concilia.getMontoMov()) > 0){
									cant=Float.parseFloat(concilia.getMontoMov());
								}else{
									if(concilia.getNatMovimiento().equals(abono)){
										motivo= "Valor Incorrecto para Abonos ";
									}else{
										motivo= "Valor Incorrecto para Cargos ";
									}
									resultadoBean.setDescripcion(motivo);
									resultadoBean.setNumero(999);
									fallidos = fallidos+1;
									throw new Exception(resultadoBean.getDescripcion());
								}
								// se valida que el movimiento este entre el rango de fechas, si no esta simplemente no lo agrega
								Date fechaInicial;
								Date fechaFinal;
								Date fechaConcilia;
								fechaInicial = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaInicial());
								fechaFinal = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaFinal());
								fechaConcilia = OperacionesFechas.conversionStrDate(concilia.getFechaOperacion());
								if( fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal) )
								{
									resultadoBean= altaTesoMovsConc(tesoConcilia, concilia, transaccion);
									exitos = exitos+resultadoBean.getExitosos();
									fallidos = fallidos+resultadoBean.getFallidos();
									if(resultadoBean.getFallidos()>0){
										exitos = 0;
										fallidos = tamanoLista;
										resultadoBean.setNumero(999);
										resultadoBean.setDescripcion(resultadoBean.getDescripcion()+saltoLinea+"Intente cargar de nuevo el archivo.");
										throw new Exception(resultadoBean.getDescripcion());
									}
									else{
										resultadoBean.setExitosos(exitos);
										resultadoBean.setFallidos(fallidos);
										resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido
														);
									}
								}else{
									motivoexcluido = saltoLinea+ "Motivo Exclusión: La fecha de los movimientos no coincide con el rango de fechas de carga.";
									fallidos += 1;
									resultadoBean.setExitosos(exitos);
									resultadoBean.setFallidos(fallidos);
									resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido
													);
								}
							}
						}
					}else{// si no se leyo el archivo devuelve un mensaje
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Asegurese de Seleccionar el Archivo Correcto.");
						throw new Exception(resultadoBean.getDescripcion());
					}
					} catch (Exception e) {
						e.printStackTrace();

						resultadoBean.setNumero(999);
						transaction.setRollbackOnly();
					}
				return resultadoBean;
			}
		});
		return resultado;
	}


	// proceso para leer y dar de alta movimientos de conciliacion para institucion Bancomer
	public ResultadoCargaArchivosTesoreriaBean cargaArchTesoMovsConcBancomer(final TesoMovsArchConciliaBean tesoConcilia,
			final String rutaArchivo){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				//Declaracion de Variables
				ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();	// bean para manejo de errores y resultados
				List<TesoMovsArchConciliaBean> listConcilia = null;		// lista de beans para obtener la lista de conciliaciones del archivo.
				Iterator<TesoMovsArchConciliaBean> iterList=null;		// iterador para el manejo de la lista
				TesoMovsArchConciliaBean concilia=null;					// apuntador para cada bean que devuelva la consulta de la lista
				BufferedReader bufferedReader=null;						// lee el archivo hasta el salto de linea
				String nombreOri	=rutaArchivo;						// Se almacena el en nombre de la ruta de origen
				String tokens[]		=nombreOri.split("[.]");			// Arreglo para separar los el nombre del archivo con su extension
				String extension	="."+tokens[1];						// Se almacena el nombre de la extension
				String motivo		="";								// descripcion de los fallos
				String renglon		="";								// renglon actual de la iteracion
				int tamanoLista		=0;									// tamaño de la lista (listConcilia)
				int contador		=1;									// es el contador que representa las lineas de los registros
				int contadorerr		=1;									// contador de errores
				int exitos			=0;									// contador de exitos
				int fallidos		=0;									// contador de fallos
				float cant			=0;									// cantidad del monto de movimiento
				long transaccion	= 0;								// transaccion de la operacion actual, que seria de la carga de archivo
				boolean error		=true;								// bandera de error
				String motivoexcluido = "";								// motivo por la que se excluyen

				try{
					if(extension.equals(".csv")){
						listConcilia=leeArchivoTesoMovsConBancomerCsv(rutaArchivo);
					}else{
						if(extension.equals(".exp") || extension.equals(".txt") ){
							switch (Utileria.convierteEntero(tesoConcilia.getVersionFormato())) {
							case Enum_VersionArchivo.Anterior:
								listConcilia = leeArchivoTesoMovsConBancomerExpTxt(rutaArchivo);
								break;
							case Enum_VersionArchivo.Actual:
								listConcilia = leeFormatoActualBancomer(rutaArchivo);
								break;
							default:
								listConcilia = null;
								break;
							}

						}
					}


					if(listConcilia!=null){
						iterList=listConcilia.iterator();
						if(extension.equals(".csv") ||extension.equals(".exp") ||extension.equals(".txt")  ){
							// si la lista no esta vacia quiere decir que se leyo correctamente el archivo
							transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
								// while para recorrer el arreglo de beans que se creo al leer el archivo
							while(iterList.hasNext()){
								contador = contador+1;
								concilia=(TesoMovsArchConciliaBean) iterList.next();
								tamanoLista = concilia.getTamanioListaCarga();
								if(concilia.getCuentaAhoID()!=null){
									if(concilia.getCuentaAhoID().equals("123")){
										fallidos = fallidos+1;
										motivo= concilia.getDescripcionMov();
										resultadoBean.setNumero(123);
										resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "
													+tamanoLista + saltoLinea+motivo);
										throw new Exception(resultadoBean.getDescripcion());
									}
								}else{
									// se valida que el movimiento sea de la misma fecha de carga: que este entre fechas
									Date fechaInicial;
									Date fechaFinal;
									Date fechaConcilia;
									fechaInicial = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaInicial());
									fechaFinal = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaFinal());
									fechaConcilia = OperacionesFechas.conversionStrDate(concilia.getFechaOperacion());
									if( fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal) )
									{
										resultadoBean= altaTesoMovsConc(tesoConcilia, concilia, transaccion);
										exitos = exitos+resultadoBean.getExitosos();
										fallidos = fallidos+resultadoBean.getFallidos();
										if(resultadoBean.getFallidos()>0){
											exitos = 0;
											fallidos = tamanoLista;
											resultadoBean.setNumero(999);
											resultadoBean.setDescripcion(resultadoBean.getDescripcion()+saltoLinea+"Intente cargar de nuevo el archivo.");
											throw new Exception(resultadoBean.getDescripcion());
										}
										else{
											resultadoBean.setExitosos(exitos);
											resultadoBean.setFallidos(fallidos);
											resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido
															);
										}
									}else{
										motivoexcluido = saltoLinea+ "Motivo Exclusión: La fecha de los movimientos no coincide con el rango de fechas de carga.";
										fallidos += 1;
										resultadoBean.setExitosos(exitos);
										resultadoBean.setFallidos(fallidos);
										resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido
														);
									}
								}
							}
							}else{
								resultadoBean.setNumero(999);
								resultadoBean.setDescripcion("Error al Cargar, Asegurese de Seleccionar el Archivo Correcto. La extensión seleccionada debe ser 'txt','exp' o 'csv'");
								throw new Exception(resultadoBean.getDescripcion());
							}
					}else{
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Error al Cargar, Asegúrese de seleccionar el formato del archivo correctamente.");
						throw new Exception(resultadoBean.getDescripcion());
					}

				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en validacion de fecha de conciliacion", e);
					switch(resultadoBean.getNumero()){
					case 123:
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(resultadoBean.getDescripcion());
						break;
					default:
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "+
								fallidos +saltoLinea+ "Error en línea: "+ contador+saltoLinea+" Motivo: "+resultadoBean.getDescripcion());
						break;
					}
					transaction.setRollbackOnly();
				}
				return resultadoBean;
			}
		});
		return resultado;
	}


	// lee el archivo con banco Banorte
	public List<TesoMovsArchConciliaBean> leeArchivoTesoMovsConcBanorte(String nombreArchivo){
		// Orden de los datos:
		// Fecha|Movimiento|Cód. Trans.|Concepto|Retiros|Depósitos|Saldos|Cheque

		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;

		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 1;
		int numCamposEncabezado = 8;
		// encabezados
		String fechaOperacion="";
		String descripcion="";
		String referencia="";
		String depositos = "";
		String retiros = "";
		String fecha = "";
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
					numeroLinea +=1;
					if(numeroLinea>tamEncabezado){
						conciliaBeanRes = new TesoMovsArchConciliaBean();
						arreglo = renglon.split("\\|");
						if(arreglo.length == numCamposEncabezado || arreglo.length == 7){
							// para la funcion de validacionde fecha pide el formato dd/mm/aaaa por eso reacomodamos los dias
							if(arreglo[0].trim().split("\\/").length == 3){
								fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+arreglo[0].trim().split("\\/")[1]+"-"+arreglo[0].trim().split("\\/")[0];
								fecha = fechaOperacion;
						        int enero = fecha.indexOf("Ene");
						        int febrero = fecha.indexOf("Feb");
						        int marzo = fecha.indexOf("Mar");
						        int abril = fecha.indexOf("Abr");
						        int mayo = fecha.indexOf("May");
						        int junio = fecha.indexOf("Jun");
						        int julio = fecha.indexOf("Jul");
						        int agosto = fecha.indexOf("Ago");
						        int septiembre = fecha.indexOf("Sep");
						        int octubre = fecha.indexOf("Oct");
						        int noviembre = fecha.indexOf("Nov");
						        int diciembre = fecha.indexOf("Dic");

						        if(enero != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"01"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(febrero != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"02"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(marzo != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"03"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(abril != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"04"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(mayo != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"05"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(junio != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"06"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(julio != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"07"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(agosto != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"08"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(septiembre != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"09"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(octubre != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"10"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(noviembre != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"11"+"-"+arreglo[0].trim().split("\\/")[0];
						        }
						        if(diciembre != -1) {
						        	fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"12"+"-"+arreglo[0].trim().split("\\/")[0];
						        }

							}else{
								fechaOperacion 	= "";
							}
							descripcion		=arreglo[3].trim();
							referencia		=arreglo[2].trim();
							depositos = arreglo[5].trim().replaceAll(",","").replaceAll("\\$", "");
							retiros = arreglo[4].trim().replaceAll(",","").replaceAll("\\$", "");
							try{
								fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
								}catch(Exception e){
									e.printStackTrace();
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion"+fechaOperacion,e);
									fechaValida=false;
							}
							if(fechaValida){
										try{
											conciliaBeanRes.setFechaOperacion(fechaOperacion);

											if(descripcion.length() > 150){
												descripcion = descripcion.substring(0, 150);
											}
											if(descripcion.length()<=150 && descripcion.length()>0){
												conciliaBeanRes.setDescripcionMov(descripcion);
												if(referencia.length()<=150){
													conciliaBeanRes.setReferencia(referencia);
													// validaciones extras para saber si estan vacios los datos de montos...
													if(!depositos.isEmpty() && !retiros.isEmpty()){
														if(validaNaturaMontos(depositos, retiros)){
															if(esCantidadPositivaMayorCero(depositos)){
																conciliaBeanRes.setNatMovimiento(abono);
																conciliaBeanRes.setMontoMov(depositos);
															}else if(esCantidadPositivaMayorCero(retiros)){
																conciliaBeanRes.setNatMovimiento(cargo);
																conciliaBeanRes.setMontoMov(retiros);
															}else{
																conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto es negativo o no coincide con el formato numérico.");
																conciliaBeanRes.setCuentaAhoID("123");
																loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
															}
														}else{
															conciliaBeanRes.setCuentaAhoID("123");
															conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
															loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
														}
													}else{
														conciliaBeanRes.setCuentaAhoID("123");
														if(	depositos.isEmpty()	&& retiros.isEmpty()){
															conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Los montos de Depósitos y Retiros se encuentran vacíos");
															loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
														}else if(depositos.isEmpty()){
															conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Depósitos se encuentra vacío");
															loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
														}else {
															conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Retiros se encuentra vacío");
															loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
														}
													}
												}
												else{
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
													conciliaBeanRes.setCuentaAhoID("123");//123 quiere decir que se encontro un error
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}
											}
											else if(descripcion.length()<=0){
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El campo descripción se encuentra vacío.");
												conciliaBeanRes.setCuentaAhoID("123");
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}else{
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La descripción sobrepasa el límite de 150 caracteres");
												conciliaBeanRes.setCuentaAhoID("123");
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}
										}catch(Exception e){
											loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											conciliaBeanRes.setCuentaAhoID("123");
										}
									}else{
										conciliaBeanRes.setCuentaAhoID("123");
										conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
									}
								}else{
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
									conciliaBeanRes.setCuentaAhoID("123");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}
								listaArchivoMovsConc.add(conciliaBeanRes);
							}
						}
						bufferedReader.close();
					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion leeArchivoTesoMovsConcBanorte.");
					}
					Iterator<TesoMovsArchConciliaBean> iterList = null;
					iterList = listaArchivoMovsConc.iterator();
					int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
					if(tamanioLista<0){
						tamanioLista = 0;
					}
					while(iterList.hasNext()){
						iterList.next().setTamanioListaCarga(tamanioLista);
					}
			return listaArchivoMovsConc;
	}

	//metodo que lee el layout de BANCOMER con extension .csv, este metodo se heredo de Daniel Carrasco
	// y se asume que el layuot se lo proporciono findasa
	public List<TesoMovsArchConciliaBean> leeArchivoTesoMovsConBancomerCsv(String nombreArchivo){
		// Orden de los datos:
		// Día|Concepto / Referencia|cargo|Abono|Saldo
		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		String [] descripcionreferencia = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;
		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 1;
		int numCamposEncabezado = 5;
		// encabezados
		String fechaOperacion="";
		String concepto="";
		String referencia="";
		double cargo=0;
		double abono=0;
		String campodesref="";
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				numeroLinea +=1;
				if(numeroLinea>tamEncabezado){
					conciliaBeanRes = new TesoMovsArchConciliaBean();
					arreglo = renglon.split("\\|");
					if(arreglo.length == numCamposEncabezado){
						// para la funcion de validacionde fecha pide el formato aaa/mm/dd por eso reacomodamos los dias
						if(arreglo[0].trim().split("\\/").length == 3){
							fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+arreglo[0].trim().split("\\/")[1]+"-"+arreglo[0].trim().split("\\/")[0];
						}else{
							fechaOperacion 	= "";
						}
						campodesref = arreglo[1].trim();
						descripcionreferencia = campodesref.split("\\/");

						if(!campodesref.startsWith("/")&&(descripcionreferencia.length == 2   || descripcionreferencia.length == 1 )){
							if (descripcionreferencia.length == 2 && !campodesref.startsWith("/"))
							{	referencia 	= descripcionreferencia[1].trim();
								concepto	= descripcionreferencia[0].trim();
							}
							else {
								referencia = "";
								concepto = descripcionreferencia[0].trim();
							}
							cargo = convCanPositiva(	arreglo[2].trim().replaceAll(",","").replaceAll("\\$", ""));
							abono = convCanPositiva(	arreglo[3].trim().replaceAll(",","").replaceAll("\\$", ""));

							try{	fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
							}catch(Exception e){
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion");
								fechaValida=false;
							}
							if(fechaValida){
									try{
										conciliaBeanRes.setFechaOperacion(fechaOperacion);
										if(concepto.length()<=150 && concepto.length()>0){
											conciliaBeanRes.setDescripcionMov(concepto);
											if(referencia.length()<=150){
												conciliaBeanRes.setReferencia(referencia);
												if(!arreglo[3].trim().isEmpty() || !arreglo[2].trim().isEmpty()){
													if(abono > 0){
														conciliaBeanRes.setNatMovimiento("A");
														conciliaBeanRes.setMontoMov(arreglo[3].trim().replaceAll(",","").replaceAll("\\$",""));
													}
													else if(cargo > 0 ){
														conciliaBeanRes.setNatMovimiento("C");
														conciliaBeanRes.setMontoMov(arreglo[2].trim().replaceAll(",","").replaceAll("\\$",""));

													}else{
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto es negativo o no coincide con el formato numérico en los campos cargo y abono.");
														conciliaBeanRes.setCuentaAhoID("123");
													}

													if(!validaNaturaMontos(arreglo[2].trim().replaceAll(",","").replaceAll("\\$",""),
														arreglo[3].trim().replaceAll(",","").replaceAll("\\$","") ) ){
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
														conciliaBeanRes.setCuentaAhoID("123");
													}
												}else{
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto esta vacío en los campos cargo y abono.");
													conciliaBeanRes.setCuentaAhoID("123");
												}
											}
											else{
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
												conciliaBeanRes.setCuentaAhoID("123");
											}
										}
										else if(concepto.length()<=0){
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Concepto está vacío.");
											conciliaBeanRes.setCuentaAhoID("123");
										}else{
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La descripción sobrepasa el límite de 150 caracteres.");
											conciliaBeanRes.setCuentaAhoID("123");
										}

									} catch (Exception e) {
										e.printStackTrace();
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivos de tesoreria movimientos de conciliacion de bancomer", e);
									}
								}else{
									conciliaBeanRes.setCuentaAhoID("123");
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}
							}else {
								conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Concepto está vacío.");
								conciliaBeanRes.setCuentaAhoID("123");
							}
					}
					else{
						conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
						conciliaBeanRes.setCuentaAhoID("123");
					}
					listaArchivoMovsConc.add(conciliaBeanRes);
				}
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al leer archivos de tesoreria movimientos de conciliacion de bancomer", e);
		}
						Iterator<TesoMovsArchConciliaBean> iterList = null;
				iterList = listaArchivoMovsConc.iterator();
				int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
				if(tamanioLista<0){
					tamanioLista = 0;
				}
				while(iterList.hasNext()){
					iterList.next().setTamanioListaCarga(tamanioLista);
				}
		return listaArchivoMovsConc;
	}

	//MEtodo para cargar layout de BANCOMER en tipo de extension .exp y .txt
	public List<TesoMovsArchConciliaBean> leeArchivoTesoMovsConBancomerExpTxt(String nombreArchivo){
		// Orden de los datos:
		// Día	Concepto / Referencia	cargo	Abono	Saldo
		// dd-mm-aaaa
		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		String [] descripcionreferencia = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;
		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 1;
		int numCamposEncabezado = 5;//aunque son 6 el saldo no se usa
		// encabezados
		String fechaOperacion="";
		String concepto="";
		String referencia="";
		double cargo=0;
		double abono=0;
		String campodesref="";
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				numeroLinea +=1;
				if(numeroLinea>tamEncabezado){
					conciliaBeanRes = new TesoMovsArchConciliaBean();
					arreglo = renglon.split("\\t");
					if(arreglo.length == numCamposEncabezado){
						// para la funcion de validacionde fecha pide el formato aaa/mm/dd por eso reacomodamos los dias
						if(arreglo[0].trim().split("-").length == 3){
							fechaOperacion 	=arreglo[0].trim().split("-")[2]+"-"+arreglo[0].trim().split("-")[1]+"-"+arreglo[0].trim().split("-")[0];
						}else{
							fechaOperacion 	= "";
						}
						campodesref = arreglo[1].trim();
						descripcionreferencia = campodesref.split("\\/");

						if(!campodesref.startsWith("/")&&(descripcionreferencia.length == 2   || descripcionreferencia.length == 1 )){
							if (descripcionreferencia.length == 2 && !campodesref.startsWith("/"))
							{	referencia 	= descripcionreferencia[1].trim();
								concepto	= descripcionreferencia[0].trim();
							}
							else {
								referencia = "";
								concepto = descripcionreferencia[0].trim();
							}
							cargo = convCanPositiva(	arreglo[2].trim().replaceAll(",","").replaceAll("\\$", ""));
							abono = convCanPositiva(	arreglo[3].trim().replaceAll(",","").replaceAll("\\$", ""));

							try{	fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
							}catch(Exception e){
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion["+fechaOperacion+"]["+arreglo[0].trim()+"]" );
								fechaValida=false;
							}
							if(fechaValida){
									try{
										conciliaBeanRes.setFechaOperacion(fechaOperacion);
										if(concepto.length()<=150 && concepto.length()>0){
											conciliaBeanRes.setDescripcionMov(concepto);
											if(referencia.length()<=150){
												conciliaBeanRes.setReferencia(referencia);
												if(!arreglo[3].trim().isEmpty() || !arreglo[2].trim().isEmpty()){

													if(abono > 0){
														conciliaBeanRes.setNatMovimiento("A");
														conciliaBeanRes.setMontoMov(arreglo[3].trim().replaceAll(",","").replaceAll("\\$",""));
													}
													else if(cargo > 0 ){
														conciliaBeanRes.setNatMovimiento("C");
														conciliaBeanRes.setMontoMov(arreglo[2].trim().replaceAll(",","").replaceAll("\\$",""));

													}else{
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto es negativo o no coincide con el formato numérico en los campos cargo y abono.");
														conciliaBeanRes.setCuentaAhoID("123");
													}

													if(!validaNaturaMontos(arreglo[2].trim().replaceAll(",","").replaceAll("\\$",""),
														arreglo[3].trim().replaceAll(",","").replaceAll("\\$","") ) ){
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
														conciliaBeanRes.setCuentaAhoID("123");
													}
												}else{
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto esta vacío en los campos cargo y abono.");
													conciliaBeanRes.setCuentaAhoID("123");
												}
											}
											else{
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
												conciliaBeanRes.setCuentaAhoID("123");
											}
										}
										else if(concepto.length()<=0){
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Concepto está vacío.");
											conciliaBeanRes.setCuentaAhoID("123");
										}else{
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La descripción sobrepasa el límite de 150 caracteres.");
											conciliaBeanRes.setCuentaAhoID("123");
										}

									} catch (Exception e) {
										e.printStackTrace();
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivos de tesoreria movimientos de conciliacion de bancomer", e);
									}
								}else{
									conciliaBeanRes.setCuentaAhoID("123");
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}
							}else {
								conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Concepto está vacío.");
								conciliaBeanRes.setCuentaAhoID("123");
							}
					}else{
						conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
						conciliaBeanRes.setCuentaAhoID("123");
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov()+arreglo.length +"  "+ numCamposEncabezado+" número de linea:"+numeroLinea);
					}
					listaArchivoMovsConc.add(conciliaBeanRes);
				}
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivos de tesoreria movimientos de conciliacion de bancomer", e);
		}
		Iterator<TesoMovsArchConciliaBean> iterList = null;
				iterList = listaArchivoMovsConc.iterator();
				int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
				if(tamanioLista<0){
					tamanioLista = 0;
				}
				while(iterList.hasNext()){
					iterList.next().setTamanioListaCarga(tamanioLista);
				}
				return listaArchivoMovsConc;
		}

	// lee el archivo con formato Estandar
	public List<TesoMovsArchConciliaBean> leeArchivoTesoMovsConcEstandar(String nombreArchivo){
		// Orden de los datos:Fecha de OperaciÃ³n|Descripcion|Referencia|DepÃ³sitos|Retiros|
		// Fecha de Operación dd/mm/aaaa
		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		TesoMovsArchConciliaBean conciliaBeanRest;
		String renglon;
		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 1;
		int numCamposEncabezado = 5;
		// encabezados
		String fechaOperacion="";
		String descripcion="";
		String referencia="";
		String depositos="";
		String retiros="";
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				numeroLinea +=1;
				if(numeroLinea>tamEncabezado){
					conciliaBeanRes = new TesoMovsArchConciliaBean();
					arreglo = renglon.split("\\|");
					if(arreglo.length == numCamposEncabezado){
						// para la funcion de validacionde fecha pide el formato aaa/mm/dd por eso reacomodamos los dias
						if(arreglo[0].trim().split("\\/").length == 3){
							fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+arreglo[0].trim().split("\\/")[1]+"-"+arreglo[0].trim().split("\\/")[0];
						}else{
							fechaOperacion 	= "";
						}

						descripcion		=arreglo[1].trim();
						referencia		=arreglo[2].trim();
						depositos		=arreglo[3].trim().replaceAll(",","").replaceAll("\\$", "");
						retiros			=arreglo[4].trim().replaceAll(",","").replaceAll("\\$", "");

						try{
							fechaValida = OperacionesFechas.validarFecha(fechaOperacion);

							}catch(Exception e){
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion"+fechaOperacion,e);
								fechaValida=false;
						}


						if(fechaValida){
									try{
										conciliaBeanRes.setFechaOperacion(fechaOperacion);
										if(descripcion.length()<=150 && descripcion.length()>0){
											conciliaBeanRes.setDescripcionMov(descripcion);
											if(referencia.length()<=150){
												conciliaBeanRes.setReferencia(referencia);
												if(!depositos.isEmpty() && !retiros.isEmpty()){
													if(validaNaturaMontos(	depositos 	,	retiros 	)) {
														double deposito = convCanPositiva(	depositos);
														double retiro = convCanPositiva(  	retiros);
														if(deposito>0 && retiro <= 0){
															conciliaBeanRes.setNatMovimiento(abono);
															conciliaBeanRes.setMontoMov(depositos);
														}
														else if(retiro>0 && deposito <= 0)
														{
															conciliaBeanRes.setNatMovimiento(cargo);
															conciliaBeanRes.setMontoMov(retiros);
														}else{
															conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
															conciliaBeanRes.setCuentaAhoID("123");
															loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov()+" depositos: "+depositos+" retiros: "+retiros+ " else");
														}

													}else{
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
														conciliaBeanRes.setCuentaAhoID("123");
														loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov()+" depositos: "+depositos+" retiros: "+retiros+ " validaNaturaMontos");
													}
												}else{
													conciliaBeanRes.setCuentaAhoID("123");
													if(depositos.isEmpty() && retiros.isEmpty()){
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Los montos de los campos Depósitos y Retiros se encuentran vacíos");
													}else if(depositos.isEmpty()){
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Depósitos se encuentra vacío");
													}else {
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Retiros se encuentra vacío");
													}
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}
											}
											else{
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
												conciliaBeanRes.setCuentaAhoID("123");//123 quiere decir que se encontro un error
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}
										}
										else if(descripcion.length()<=0){
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El campo descripción se encuentra vacío.");
											conciliaBeanRes.setCuentaAhoID("123");
											loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										}else{
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La descripción sobrepasa el límite de 150 caracteres");
											conciliaBeanRes.setCuentaAhoID("123");
											loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										}
									}catch(Exception e){
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										conciliaBeanRes.setCuentaAhoID("123");
									}
								}else{
									conciliaBeanRes.setCuentaAhoID("123");
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}


							}else{
								conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
								conciliaBeanRes.setCuentaAhoID("123");
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
							}
							listaArchivoMovsConc.add(conciliaBeanRes);
						}
					}
						if(numeroLinea==1){
							conciliaBeanRest = new TesoMovsArchConciliaBean();
							conciliaBeanRest.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
							conciliaBeanRest.setCuentaAhoID("123");
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRest.getDescripcionMov());
							listaArchivoMovsConc.add(conciliaBeanRest);
						}
					 bufferedReader.close();

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion leeArchivoTesoMovsConcEstandar.");
				}
				Iterator<TesoMovsArchConciliaBean> iterList = null;
				iterList = listaArchivoMovsConc.iterator();
				int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
				if(tamanioLista<0){
					tamanioLista = 0;
				}
				while(iterList.hasNext()){
					iterList.next().setTamanioListaCarga(tamanioLista);
				}
				return listaArchivoMovsConc;
		}
	/**
	 * Lee el nuevo formato actualizado para el banco Banorte (13 columnas en el encabezado).
	 * @param nombreArchivo Ruta del archivo cargado.
	 * @return Lista con los movimientos de carga.
	 */
	public List<TesoMovsArchConciliaBean> leeFormatoActualBanorte(String nombreArchivo){
		/** Orden de los datos en el encabezado:
		 * Cuenta|Fecha de Operación|Fecha|Referencia|Descripción|Cod. Transac|Sucursal|Depósitos|Retiros|Saldo|Movimiento|Descripción Detallada|Cheque
		 * 00    |01                |02   |03        |04         |05          |06      |07       |08     |09   |10        |11                   |12
		 */
		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;

		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 1;
		int numCamposEncabezado = 13;
		// encabezados
		String fechaOperacion="";
		String descripcion="";
		String referencia="";
		String depositos = "";
		String retiros = "";
		String fecha = "";
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			for(renglon = bufferedReader.readLine(); renglon != null; renglon = bufferedReader.readLine()){
				numeroLinea +=1;
				if(numeroLinea>tamEncabezado){
					conciliaBeanRes = new TesoMovsArchConciliaBean();
					arreglo = renglon.split("\\|");
					if(arreglo.length <= numCamposEncabezado){
						/** Para la funcion de validacionde fecha pide el formato dd/mm/aaaa.*/
						if(arreglo[1].trim().split("\\/").length == 3){
							fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+arreglo[1].trim().split("\\/")[1]+"-"+arreglo[1].trim().split("\\/")[0];
							fecha = fechaOperacion;
							int enero = fecha.indexOf("Ene");
							int febrero = fecha.indexOf("Feb");
							int marzo = fecha.indexOf("Mar");
							int abril = fecha.indexOf("Abr");
							int mayo = fecha.indexOf("May");
							int junio = fecha.indexOf("Jun");
							int julio = fecha.indexOf("Jul");
							int agosto = fecha.indexOf("Ago");
							int septiembre = fecha.indexOf("Sep");
							int octubre = fecha.indexOf("Oct");
							int noviembre = fecha.indexOf("Nov");
							int diciembre = fecha.indexOf("Dic");

							if(enero != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"01"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(febrero != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"02"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(marzo != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"03"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(abril != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"04"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(mayo != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"05"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(junio != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"06"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(julio != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"07"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(agosto != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"08"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(septiembre != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"09"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(octubre != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"10"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(noviembre != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"11"+"-"+arreglo[1].trim().split("\\/")[0];
							}
							if(diciembre != -1) {
								fechaOperacion 	=arreglo[1].trim().split("\\/")[2]+"-"+"12"+"-"+arreglo[1].trim().split("\\/")[0];
							}
						}else{
							fechaOperacion 	= "";
						}
						descripcion		=arreglo[4].trim();
						referencia		=arreglo[3].trim();
						depositos = arreglo[7].trim().replaceAll(",","").replaceAll("\\$", "");
						retiros = arreglo[8].trim().replaceAll(",","").replaceAll("\\$", "");
						try{
							fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
						}catch(Exception e){
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion "+fechaOperacion,e);
							fechaValida=false;
						}
						if(fechaValida){
							try{
								conciliaBeanRes.setFechaOperacion(fechaOperacion);
								if(descripcion.length() > 150){
									descripcion = descripcion.substring(0, 149);
								}
								if(descripcion.length()<=150 && descripcion.length()>0){
									conciliaBeanRes.setDescripcionMov(descripcion);
									if(referencia.length()<=150){
										conciliaBeanRes.setReferencia(referencia);
										// validaciones extras para saber si estan vacios los datos de montos...
										if(!depositos.isEmpty() && !retiros.isEmpty()){
											if(validaNaturaMontos(depositos, retiros)){
												if(esCantidadPositivaMayorCero(depositos)){
													conciliaBeanRes.setNatMovimiento(abono);
													conciliaBeanRes.setMontoMov(depositos);
												}else if(esCantidadPositivaMayorCero(retiros)){
													conciliaBeanRes.setNatMovimiento(cargo);
													conciliaBeanRes.setMontoMov(retiros);
												}else{
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto es negativo o no coincide con el formato numérico.");
													conciliaBeanRes.setCuentaAhoID("123");
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}
											}else{
												conciliaBeanRes.setCuentaAhoID("123");
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}
										}else{
											conciliaBeanRes.setCuentaAhoID("123");
											if(	depositos.isEmpty()	&& retiros.isEmpty()){
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Los montos de Depósitos y Retiros se encuentran vacíos");
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}else if(depositos.isEmpty()){
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Depósitos se encuentra vacío");
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}else {
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Retiros se encuentra vacío");
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}
										}
									}
									else{
										conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
										conciliaBeanRes.setCuentaAhoID("123");//123 quiere decir que se encontro un error
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
									}
								}
								else if(descripcion.length()<=0){
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El campo descripción se encuentra vacío.");
									conciliaBeanRes.setCuentaAhoID("123");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}else{
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La descripción sobrepasa el límite de 150 caracteres");
									conciliaBeanRes.setCuentaAhoID("123");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}
							}catch(Exception e){
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								conciliaBeanRes.setCuentaAhoID("123");
							}
						}else{
							conciliaBeanRes.setCuentaAhoID("123");
							conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
						}
					}else{
						conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
						conciliaBeanRes.setCuentaAhoID("123");
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
					}
					listaArchivoMovsConc.add(conciliaBeanRes);
				}
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion leeFormatoActualBanorte.");
		}
		Iterator<TesoMovsArchConciliaBean> iterList = null;
		iterList = listaArchivoMovsConc.iterator();
		int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
		if(tamanioLista<0){
			tamanioLista = 0;
		}
		while(iterList.hasNext()){
			iterList.next().setTamanioListaCarga(tamanioLista);
		}
		return listaArchivoMovsConc;
	}
	/**
	 * Lee el formato actualizado para el banco Banamex.
	 * @param nombreArchivo Ruta del archivo cargado.
	 * @return Lista con los movimientos de carga.
	 */
	public List<TesoMovsArchConciliaBean> leeFormatoActualBanamex(String nombreArchivo){
		/** Orden de los datos en el encabezado:
		 * Fecha|Referencia Alfanumérica y Concepto|Cargo|Abono
		 * 00   |01                                |02   |03
		 * Formato de la Fecha: 01/10/2018.
		 * 					   [		  ]
		 * Formato de la Referencia y Concepto:      0000069419 DEPOSITO DE         69419 SUC. VILLAGRAN AUT.00148169
		 * 									  [Referencia      |Concepto o descripción	                             ]
		 */
		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		String [] arregloAux = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;

		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 5;
		int numCamposEncabezado = 4;
		// encabezados
		String fechaOperacion = "";
		String descripcion	= "";
		String referencia	= "";
		String referenciaConcepto = "";
		String depositos	= "";
		String retiros		= "";
		String fecha		= "";
		double depositosAux	= 0.00;
		double retirosAux	= 0.00;

		String  ultimoCaract = "";

		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			for(renglon = bufferedReader.readLine(); renglon != null; renglon = bufferedReader.readLine()){
				numeroLinea +=1;
				/** Se comprueba que el renglón sea un movimiento, debe de venir cargos o abonos.*/
				if(numeroLinea>tamEncabezado){
					/** Se obtiene el último caracter del reglón.*/
					ultimoCaract = String.valueOf(renglon.charAt(renglon.length() - 1));
					/** Si el renglón termina en pipe, se le agrega un cero para poder leer completo el arreglo.*/
					renglon = (ultimoCaract.equalsIgnoreCase("|")?renglon+"0":renglon);
					arregloAux = renglon.split("\\|");
					if(arregloAux.length == numCamposEncabezado){
						retirosAux	= (Utileria.convierteDoble(arregloAux[2].trim().replaceAll(",","").replaceAll("\\$", "")));
						depositosAux= (Utileria.convierteDoble(arregloAux[3].trim().replaceAll(",","").replaceAll("\\$", "")));
					} else {
						retirosAux = 0;
						depositosAux = 0;
					}
				} else {
					retirosAux = 0;
					depositosAux = 0;
				}

				/** Se valida que exista al menos una cantidad en el renglón.*/
				if((retirosAux + depositosAux) != 0.00){
					if(numeroLinea>tamEncabezado){
						conciliaBeanRes = new TesoMovsArchConciliaBean();
						arreglo = renglon.split("\\|");
						if(arreglo.length == numCamposEncabezado){
							// para la funcion de validacionde fecha pide el formato dd/mm/aaaa por eso reacomodamos los dias
							if(arreglo[0].trim().split("\\/").length == 3){
								fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+arreglo[0].trim().split("\\/")[1]+"-"+arreglo[0].trim().split("\\/")[0];
								fecha = fechaOperacion;
								int enero = fecha.indexOf("Ene");
								int febrero = fecha.indexOf("Feb");
								int marzo = fecha.indexOf("Mar");
								int abril = fecha.indexOf("Abr");
								int mayo = fecha.indexOf("May");
								int junio = fecha.indexOf("Jun");
								int julio = fecha.indexOf("Jul");
								int agosto = fecha.indexOf("Ago");
								int septiembre = fecha.indexOf("Sep");
								int octubre = fecha.indexOf("Oct");
								int noviembre = fecha.indexOf("Nov");
								int diciembre = fecha.indexOf("Dic");

								if(enero != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"01"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(febrero != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"02"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(marzo != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"03"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(abril != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"04"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(mayo != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"05"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(junio != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"06"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(julio != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"07"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(agosto != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"08"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(septiembre != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"09"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(octubre != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"10"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(noviembre != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"11"+"-"+arreglo[0].trim().split("\\/")[0];
								}
								if(diciembre != -1) {
									fechaOperacion 	=arreglo[0].trim().split("\\/")[2]+"-"+"12"+"-"+arreglo[0].trim().split("\\/")[0];
								}
							}else{
								fechaOperacion 	= "";
							}
							referenciaConcepto = arreglo[1];
							referencia	= referenciaConcepto.substring(0, 16).trim();
							descripcion	= referenciaConcepto.substring(17, referenciaConcepto.length()).trim();
							retiros		= String.valueOf(Utileria.convierteDoble(arreglo[2].trim().replaceAll(",","").replaceAll("\\$", "")));
							depositos	= String.valueOf(Utileria.convierteDoble(arreglo[3].trim().replaceAll(",","").replaceAll("\\$", "")));
							try{
								fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
							}catch(Exception e){
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion "+fechaOperacion,e);
								fechaValida=false;
							}
							if(fechaValida){
								try{
									conciliaBeanRes.setFechaOperacion(fechaOperacion);
									if(descripcion.length() > 150){
										descripcion = descripcion.substring(0, 149);
									}
									if(descripcion.length()<=150 && descripcion.length()>0){
										conciliaBeanRes.setDescripcionMov(descripcion);
										if(referencia.length()<=150){
											conciliaBeanRes.setReferencia(referencia);
											// validaciones extras para saber si estan vacios los datos de montos...
											if(!depositos.isEmpty() && !retiros.isEmpty()){
												if(validaNaturaMontos(depositos, retiros)){
													if(esCantidadPositivaMayorCero(depositos)){
														conciliaBeanRes.setNatMovimiento(abono);
														conciliaBeanRes.setMontoMov(depositos);
													}else if(esCantidadPositivaMayorCero(retiros)){
														conciliaBeanRes.setNatMovimiento(cargo);
														conciliaBeanRes.setMontoMov(retiros);
													}else{
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto es negativo o no coincide con el formato numérico.");
														conciliaBeanRes.setCuentaAhoID("123");
														loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
													}
												}else{
													conciliaBeanRes.setCuentaAhoID("123");
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Imposible identificar la naturaleza del movimiento, verificar montos.");
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}
											}else{
												conciliaBeanRes.setCuentaAhoID("123");
												if(	depositos.isEmpty()	&& retiros.isEmpty()){
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: Los montos de Depósitos y Retiros se encuentran vacíos");
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}else if(depositos.isEmpty()){
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Depósitos se encuentra vacío");
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}else {
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El monto de Retiros se encuentra vacío");
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}
											}
										}
										else{
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
											conciliaBeanRes.setCuentaAhoID("123");//123 quiere decir que se encontro un error
											loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										}
									}
									else if(descripcion.length()<=0){
										conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El campo descripción se encuentra vacío.");
										conciliaBeanRes.setCuentaAhoID("123");
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
									}else{
										conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La descripción sobrepasa el límite de 150 caracteres");
										conciliaBeanRes.setCuentaAhoID("123");
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
									}
								}catch(Exception e){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
									conciliaBeanRes.setCuentaAhoID("123");
								}
							}else{
								conciliaBeanRes.setCuentaAhoID("123");
								conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
							}
						}else{
							conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
							conciliaBeanRes.setCuentaAhoID("123");
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
						}
						listaArchivoMovsConc.add(conciliaBeanRes);
					}
				}
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion leeFormatoActualBanorte.");
		}
		Iterator<TesoMovsArchConciliaBean> iterList = null;
		iterList = listaArchivoMovsConc.iterator();
		int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
		if(tamanioLista<0){
			tamanioLista = 0;
		}
		while(iterList.hasNext()){
			iterList.next().setTamanioListaCarga(tamanioLista);
		}
		return listaArchivoMovsConc;
	}

	/**
	 * Lee el nuevo formato que se descarga directamente del banco Bancomer.
	 * @param nombreArchivo Ruta del archivo cargado.
	 * @return Lista con los movimientos de carga.
	 */
	public List<TesoMovsArchConciliaBean> leeFormatoActualBancomer(String nombreArchivo){
		/**
		 * Orden del escabezado no esta delimitado por algún caracter. Esta delimitado por posiciones.
		 * Sólo se tomarán los registros que comiencen en 22 (Registro Detalle).
		 * ENCABEZADO:      REGISTRO|CLAVE PAÍS|SUCURSAL|FECHA OPERACIÓN|FECHA VALOR|USO FUTURO|CLAVE LEYENDA|CARGO/ABONO|IMPORTE|DATO |CONCEPTO
		 * NÚM. COLUMNA:    00      |01        |02      |03             |04         |05        |06           |07         |08     |09   |10
		 * POSICIONES:      00-01   |02-05     |06-09   |10-15          |16-21      |22-23     |24-26        |27         |28-41  |42-51|52-79
		 * NÚM. CARACTERES: 02      |04        |04      |06             |06         |02        |03           |01         |14     |10   |28
		 *
		 * Ejemplo del registro:
		 * 220074172 181130181130  Y15200000000576500576500    CE00000000001074591072
		 *
		 *  2| 2| 0| 0| 7| 4| 1| 7| 2|  | 1| 8| 1| 1| 3| 0| 1| 8| 1| 1| 3| 0|  |  | Y| 1| 5| 2| 0| 0| 0| 0| 0| 0| 0| 0| 5| 7| 6| 5| 0| 0| 5| 7| 6| 5| 0| 0|  |  |  |  | C| E| 0| 0| 0| 0| 0| 0| 0| 0| 0| 0| 1| 0| 7| 4| 5| 9| 1| 0| 7| 2|  |  |  |  |  |
		 * 00|01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59|60|61|62|63|64|65|66|67|68|69|70|71|72|73|74|75|76|77|78|79
		 */
		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;
		boolean fechaValida = true;
		int registroDetalle = 22;
		int numeroLinea = 0;
		int tamEncabezado = 0;
		int longitudRegistro = 0;
		int longitudTotal= 80;
		int inicioRegistro = 0;
		final int naturalezaCargo = 01;
		final int naturalezaAbono = 02;
		int naturalezaMov = 00;
		// encabezados
		String fechaOperacion="";
		String concepto="";
		String referencia="";
		double cargo=0;
		double abono=0;
		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			for(renglon = bufferedReader.readLine(); renglon != null; renglon = bufferedReader.readLine()){
				numeroLinea +=1;
				if(numeroLinea>tamEncabezado){
					conciliaBeanRes = new TesoMovsArchConciliaBean();
					/** Se obtienen, el tamaño del registro y los dos primeros caracteres de inicio.*/
					longitudRegistro = renglon.length();
					inicioRegistro = Utileria.convierteEntero(renglon.substring(0, 2));

					/** Se lee el registro, sólo si es de tipo detalle y si su longitud es de 80.*/
					if(inicioRegistro == registroDetalle){
						if(longitudRegistro == longitudTotal){
							/** FECHA OPERACIÓN*/
							fechaOperacion = renglon.substring(10, 16).trim();

							if(fechaOperacion.length() == 6){
								fechaOperacion 	= "20"+fechaOperacion.substring(00, 02)+"-"+fechaOperacion.substring(02, 04)+"-"+fechaOperacion.substring(04, 06);
							}else{
								fechaOperacion 	= "";
							}
							/** CLAVE LEYENDA.*/
							referencia 	= renglon.substring(24, 27).trim();
							/** CONCEPTO.*/
							concepto	= renglon.substring(52, 80).trim();

							if(!concepto.equalsIgnoreCase("")){
								/** CARGO/ABONO.*/
								naturalezaMov = Utileria.convierteEntero(renglon.substring(27,28));
								/** IMPORTE.*/
								cargo = Utileria.convierteDoble(renglon.substring(28, 40).trim().replaceAll(",","").replaceAll("\\$", "").toString()+"."+renglon.substring(40, 42).trim().replaceAll(",","").replaceAll("\\$", "").toString());
								abono = Utileria.convierteDoble(renglon.substring(28, 40).trim().replaceAll(",","").replaceAll("\\$", "").toString()+"."+renglon.substring(40, 42).trim().replaceAll(",","").replaceAll("\\$", "").toString());
								try{
									fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
								}catch(Exception e){
									e.printStackTrace();
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion["+fechaOperacion+"]." );
									fechaValida=false;
								}
								if(fechaValida){
									try{
										conciliaBeanRes.setFechaOperacion(fechaOperacion);
										if(concepto.length()<=150 && concepto.length()>0){
											conciliaBeanRes.setDescripcionMov(concepto);
											if(referencia.length()<=150){
												conciliaBeanRes.setReferencia(referencia);
												if(abono != 0){
													switch (naturalezaMov) {
													case naturalezaAbono:
														conciliaBeanRes.setNatMovimiento("A");
														conciliaBeanRes.setMontoMov(String.valueOf(abono));
														break;
													case naturalezaCargo:
														conciliaBeanRes.setNatMovimiento("C");
														conciliaBeanRes.setMontoMov(String.valueOf(cargo));
														break;
													default:
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La naturaleza del movimiento no es válida.");
														conciliaBeanRes.setCuentaAhoID("123");
														break;
													}
												}else{
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: El Monto Importe esta vacío.");
													conciliaBeanRes.setCuentaAhoID("123");
												}
											} else {
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
												conciliaBeanRes.setCuentaAhoID("123");
											}
										} else if(concepto.length()<=0){
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Concepto está vacío.");
											conciliaBeanRes.setCuentaAhoID("123");
										} else {
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La descripción sobrepasa el límite de 150 caracteres.");
											conciliaBeanRes.setCuentaAhoID("123");
										}
									} catch (Exception e) {
										e.printStackTrace();
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivos de tesoreria movimientos de conciliacion de bancomer", e);
									}
								}else{
									conciliaBeanRes.setCuentaAhoID("123");
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}
							}else {
								conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Concepto está vacío.");
								conciliaBeanRes.setCuentaAhoID("123");
							}
						}else{
							conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
							conciliaBeanRes.setCuentaAhoID("123");
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov()+"  "+ longitudRegistro+" número de linea:"+numeroLinea);
						}
						listaArchivoMovsConc.add(conciliaBeanRes);
					}
				}
			}
			bufferedReader.close();
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lee archivos de tesoreria movimientos de conciliacion de bancomer: ", e);
		}
		Iterator<TesoMovsArchConciliaBean> iterList = null;
		iterList = listaArchivoMovsConc.iterator();
		int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
		if(tamanioLista<0){
			tamanioLista = 0;
		}
		while(iterList.hasNext()){
			iterList.next().setTamanioListaCarga(tamanioLista);
		}
		return listaArchivoMovsConc;
	}

	// --------------------------- Lee Archivo txt para obtener datos de Scotiabank ------------------------------------------

	public List<TesoMovsArchConciliaBean> leeArchivoTesoMovsScotiabank(String nombreArchivo){
//		sin encabezado
//	CHQ|MXN|092|00000000002367866|2013/05/02|75351674|4.96|ABONO|191845.62|ABONO POR TRASPASO
//		fecha yyyy/MM/dd

		ArrayList<TesoMovsArchConciliaBean> listaArchivoMovsConc = new ArrayList<TesoMovsArchConciliaBean>();
		BufferedReader bufferedReader;
		String [] arreglo = null;
		TesoMovsArchConciliaBean conciliaBeanRes;
		String renglon;
		boolean fechaValida = true;
		int numeroLinea = 0;
		int tamEncabezado = 0;
		int numCamposEncabezado = 10;
		// encabezados
		String fechaOperacion="";
		String descripcion="";
		String referencia="";
		String natMovimiento = "";
		double montoMov = 0;


		try {
			bufferedReader = new BufferedReader(new FileReader(nombreArchivo));
			while ((renglon = bufferedReader.readLine())!= null && !renglon.trim().equals("")){
				numeroLinea +=1;
				if(numeroLinea>tamEncabezado){
					conciliaBeanRes = new TesoMovsArchConciliaBean();
					arreglo = renglon.split("\\|");
					if(arreglo.length == numCamposEncabezado){
						// para la funcion de validacionde fecha pide el formato aaa/mm/dd por eso reacomodamos los dias
						fechaOperacion = arreglo[4].trim().replaceAll("\\/", "-");

						descripcion		=arreglo[9].trim();
						referencia		=arreglo[5].trim();
						montoMov		=convCanPositiva(arreglo[6].trim().replaceAll("[,]","").replaceAll("[$]",""));
						natMovimiento			=arreglo[7].trim().replaceAll(",","").replaceAll("\\$", "");

						try{
							fechaValida = OperacionesFechas.validarFecha(fechaOperacion);
							}catch(Exception e){
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en tesoreria la fecha de operacion"+fechaOperacion,e);
								fechaValida=false;
						}
						if(fechaValida){
									try{
										conciliaBeanRes.setFechaOperacion(fechaOperacion);
										if(descripcion.length()<=150 && descripcion.length()>0){
											conciliaBeanRes.setDescripcionMov(descripcion);
											if(referencia.length()<=150){
												conciliaBeanRes.setReferencia(referencia);
												if(montoMov>0){
													conciliaBeanRes.setMontoMov(String.valueOf(montoMov));
													if(natMovimiento.equals("CARGO")){
														conciliaBeanRes.setNatMovimiento(cargo);
													}else if(natMovimiento.equals("ABONO")){
														conciliaBeanRes.setNatMovimiento(abono);
													}else{
														conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: La naturaleza del movimiento no esta definida (CARGO o ABONO).");
														conciliaBeanRes.setCuentaAhoID("123");
														loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
													}
												}
												else{
													conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El Monto es negativo o no coincide con el formato numérico.");
													conciliaBeanRes.setCuentaAhoID("123");
													loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
												}
											}
											else{
												conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La referencia sobrepasa el límite de 150 caracteres.");
												conciliaBeanRes.setCuentaAhoID("123");//123 quiere decir que se encontro un error
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
											}
										}
										else if(descripcion.length()<=0){
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: El campo descripción se encuentra vacío.");
											conciliaBeanRes.setCuentaAhoID("123");
											loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										}else{
											conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea+saltoLinea +" Motivo: La descripción sobrepasa el límite de 150 caracteres");
											conciliaBeanRes.setCuentaAhoID("123");
											loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										}
									}catch(Exception e){
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
										conciliaBeanRes.setCuentaAhoID("123");
									}
								}else{
									conciliaBeanRes.setCuentaAhoID("123");
									conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Valor Incorrecto para Fecha de Operación .");
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());
								}
							}else{
								conciliaBeanRes.setDescripcionMov(" Error en línea: " +numeroLinea +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
								conciliaBeanRes.setCuentaAhoID("123");
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+conciliaBeanRes.getDescripcionMov());

							}
							listaArchivoMovsConc.add(conciliaBeanRes);
						}
					}
					bufferedReader.close();
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de tesoreria movimientos de conciliacion leeArchivoTesoMovsConcEstandar.");
				}
				Iterator<TesoMovsArchConciliaBean> iterList = null;
				iterList = listaArchivoMovsConc.iterator();
				int tamanioLista = numeroLinea-tamEncabezado;//es la ultima linea leida menos el tamaño del encabezado da el total de la lista
				if(tamanioLista<0){
					tamanioLista = 0;
				}
				while(iterList.hasNext()){
					iterList.next().setTamanioListaCarga(tamanioLista);
				}
		return listaArchivoMovsConc;
	}



	// ---------------------Metodo para cargar el archivo de excel----------------------------------------
	public ResultadoCargaArchivosTesoreriaBean cargaArchTesoMovsConcScotiabank(final TesoMovsArchConciliaBean tesoConcilia,
			final String rutaArchivo){
		ResultadoCargaArchivosTesoreriaBean resultado = new ResultadoCargaArchivosTesoreriaBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (ResultadoCargaArchivosTesoreriaBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				//Declaracion de Variables
				ResultadoCargaArchivosTesoreriaBean resultadoBean = new ResultadoCargaArchivosTesoreriaBean();	// bean para manejo de errores y resultados
				List<TesoMovsArchConciliaBean> listConcilia = null;		// lista de beans para obtener la lista de conciliaciones del archivo.
				Iterator<TesoMovsArchConciliaBean> iterList=null;		// iterador para el manejo de la lista
				TesoMovsArchConciliaBean concilia=null;					// apuntador para cada bean que devuelva la consulta de la lista
				BufferedReader bufferedReader=null;						// lee el archivo hasta el salto de linea
				String nombreOri	=rutaArchivo;						// Se almacena el en nombre de la ruta de origen
				String tokens[]		=nombreOri.split("[.]");			// Arreglo para separar los el nombre del archivo con su extension
				String extension	="."+tokens[1];						// Se almacena el nombre de la extension
				String motivo		="";								// descripcion de los fallos
				String renglon		="";								// renglon actual de la iteracion
				int tamanoLista		=0;									// tamaño de la lista (listConcilia)
				int contador		=1;									// es el contador que representa las lineas de los registros
				int contadorerr		=1;									// contador de errores
				int exitos			=0;									// contador de exitos
				int fallidos		=0;									// contador de fallos
				float cant			=0;									// cantidad del monto de movimiento
				long transaccion	= 0;								// transaccion de la operacion actual, que seria de la carga de archivo
				boolean error		=true;								// bandera de error
				String motivoexcluido = "";								// motivo por la que se excluyen
				try {
					listConcilia=leeArchivoTesoMovsScotiabank(rutaArchivo);

					if(listConcilia!=null){
						iterList=listConcilia.iterator();
						if(extension.equals(".txt")){
							// si la lista no esta vacia quiere decir que se leyo correctamente el archivo
							transaccion = parametrosAuditoriaBean.getNumeroTransaccion();
							// while para recorrer el arreglo de beans que se creo al leer el archivo
							while(iterList.hasNext()){
								contador = contador+1;
								concilia=(TesoMovsArchConciliaBean) iterList.next();
								tamanoLista = concilia.getTamanioListaCarga();
								if(concilia.getCuentaAhoID()!=null){
									if(concilia.getCuentaAhoID().equals("123")){
										fallidos = fallidos+1;
										motivo= concilia.getDescripcionMov();
										resultadoBean.setNumero(123);
										resultadoBean.setDescripcion("Total Registros : "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "
												+fallidos + saltoLinea+motivo);
										throw new Exception(resultadoBean.getDescripcion());
									}
								}else{
									// se valida que el movimiento sea de la misma fecha de carga: que este entre fechas
									Date fechaInicial;
									Date fechaFinal;
									Date fechaConcilia;
									fechaInicial = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaInicial());
									fechaFinal = OperacionesFechas.conversionStrDate(tesoConcilia.getFechaCargaFinal());
									fechaConcilia = OperacionesFechas.conversionStrDate(concilia.getFechaOperacion());
									if( fechaConcilia.after(fechaInicial) && fechaConcilia.before(fechaFinal) || fechaConcilia.equals(fechaInicial) || fechaConcilia.equals(fechaFinal) )
									{
										resultadoBean= altaTesoMovsConc(tesoConcilia, concilia, transaccion);
										exitos = exitos+resultadoBean.getExitosos();
										fallidos = fallidos+resultadoBean.getFallidos();
										if(resultadoBean.getFallidos()>0){
											exitos = 0;
											fallidos = tamanoLista;
											resultadoBean.setNumero(999);
											resultadoBean.setDescripcion(resultadoBean.getDescripcion()+saltoLinea+"Intente cargar de nuevo el archivo.");
											throw new Exception(resultadoBean.getDescripcion());
										}
										else{
											resultadoBean.setExitosos(exitos);
											resultadoBean.setFallidos(fallidos);
											resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido
															);
										}
									}else{
										motivoexcluido = saltoLinea+ "Motivo Exclusión: La fecha de los movimientos no coincide con el rango de fechas de carga.";
										fallidos += 1;
										resultadoBean.setExitosos(exitos);
										resultadoBean.setFallidos(fallidos);
										resultadoBean.setDescripcion("Total Registros: "+ tamanoLista +saltoLinea+"Exitosos: "+ exitos+saltoLinea+ "Excluidos: "+fallidos+motivoexcluido
														);
									}
								}
							}
						}else{
							resultadoBean.setNumero(999);
							resultadoBean.setDescripcion("Error al Cargar, Asegurese de Seleccionar el Archivo Correcto con extensión '.txt'.");
							throw new Exception(resultadoBean.getDescripcion());
						}
					}else{
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(" Error en línea: " +contador +saltoLinea+" Motivo: Asegúrese de seleccionar el formato del archivo correctamente.");
						throw new Exception(resultadoBean.getDescripcion());
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en validacion de fecha de conciliacion", e);
					switch(resultadoBean.getNumero()){
						case 123:
							resultadoBean.setNumero(999);
							resultadoBean.setDescripcion(resultadoBean.getDescripcion());
							break;
						default:
							resultadoBean.setNumero(999);
							resultadoBean.setDescripcion("Total Registros: "+tamanoLista+ saltoLinea+"Exitosos: 0"+saltoLinea+"Fallidos: "+
									fallidos +saltoLinea+ "Error en línea: "+ contador+saltoLinea+" Motivo: "+resultadoBean.getDescripcion());
							break;
						}
						transaction.setRollbackOnly();
					}
				return resultadoBean;
			}
		});
		return resultado;
	}


	public boolean esCantidadPositivaMayorCero(String cantidad){
		float cantidadFloat=0;
		if (cantidad.isEmpty()){
			return false;
		}
		boolean resul=true;
		try{
			cantidadFloat = Float.parseFloat(cantidad);
			if(cantidadFloat<=0){
				resul=false;
				}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cantidad positiva", e);
			resul= false;
		}
		return resul;
	}

	public double convCanPositiva(String cantidad){
		double cantidadFloat=0;
		if (cantidad.isEmpty())return 0;

		try{
			cantidadFloat = Double.valueOf(cantidad);

		}catch(Exception e){
			e.printStackTrace();
			cantidadFloat=0;
		}
		return cantidadFloat;
	}

	public boolean validaNaturaMontos(String cantidad,String cantidad2){

		float cantidadFloat=0;
		float cantidadFloat2=0;

		boolean resul=true;
		try{
			if(cantidad.isEmpty()){
				cantidad = Constantes.STRING_CERO;
			}
			if(cantidad2.isEmpty()){
				cantidad2 = Constantes.STRING_CERO;
			}
			cantidadFloat = Float.parseFloat(cantidad);
			cantidadFloat2 = Float.parseFloat(cantidad2);
			if( cantidadFloat > 0.0 && cantidadFloat2 > 0.0){
				resul= false;
			}

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en valida natural montos");
			resul= false;
		}
		return resul;
	}
	public String deStringADate(String fecha){
		String [] arregloFecha=null;
		String convertFecha;
		arregloFecha=fecha.split("\\/");
		convertFecha=arregloFecha[2]+"-"+arregloFecha[1]+"-"+arregloFecha[0];
		return convertFecha;
	}
	public String deStringADate3(String fecha){
		String [] arregloFecha=null;
		String convertFecha;
		arregloFecha=fecha.split("-");
		if(arregloFecha.length>=2);
		else arregloFecha=fecha.split("\\/");
		convertFecha=arregloFecha[0]+"-"+arregloFecha[1]+"-"+arregloFecha[2];
		return convertFecha;
	}

	public String deStringADate2(String fecha){
		String [] arregloFecha=null;
		String convertFecha;
		arregloFecha=fecha.split("-");
		if(arregloFecha.length>=2);
		else arregloFecha=fecha.split("\\/");
		convertFecha=arregloFecha[2]+"-"+arregloFecha[1]+"-"+arregloFecha[0];
		return convertFecha;
	}

	public TesoMovsArchConciliaBean consultaPrincipal(TesoMovsArchConciliaBean tesoMovsConcBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TESOMOVSCONCILIACON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				tesoMovsConcBean.getInstitucionID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TesoMovsConciliaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOMOVSCONCILIACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TesoMovsArchConciliaBean tesoMovsBean = new TesoMovsArchConciliaBean();
				tesoMovsBean.setInstitucionID(resultSet.getString(1));

				return tesoMovsBean;
			}
		});
		return matches.size() > 0 ? (TesoMovsArchConciliaBean) matches.get(0) : null;
	}

	public CuentasAhoBean consultaCuentaAho(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOTESOCON(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getInstitucionID(),
				cuentasAho.getCuentaAhoID(),
				Constantes.STRING_VACIO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,


				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaSaldos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setEtiqueta(resultSet.getString("NombreSucurs"));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}


	public List listaTesoMovsConc(TesoMovsArchConciliaBean tesoMovsConcBean, int tipoLista){
		String query = "call CUENTASAHOTESOLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				tesoMovsConcBean.getCuentaAhoID(),
				tesoMovsConcBean.getInstitucionID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TesoMovsConciliaDAO.listaTesoMovsConc",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOTESOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TesoMovsArchConciliaBean tesoMovsConc = new TesoMovsArchConciliaBean();
				tesoMovsConc.setCuentaAhoID(resultSet.getString(1));
				tesoMovsConc.setDescripcionMov(resultSet.getString(2));
				tesoMovsConc.setSucursalInstit(resultSet.getString(3));
				return tesoMovsConc;
			}
		});
		return matches;
	}

	// metodo para obtener la lista de los movimientos no conciliados
	public List listaMovsNoConciliados(TesoMovsConciliaBean tesoMovsConciliaBean, int tipoLista){
		List listaMovs = null;
		try{
			String query = "call TESOMOVCONCILIALIS(?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					tesoMovsConciliaBean.getInstitucionID(),
					tesoMovsConciliaBean.getNumCtaInstit(),
					Constantes.ENTERO_CERO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasFirmaDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESOMOVCONCILIALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TesoMovsConciliaBean tesoMovsConcilia = new TesoMovsConciliaBean();
					tesoMovsConcilia.setFolioCargaID(resultSet.getString(1));
					tesoMovsConcilia.setNumeroMov(resultSet.getString(2));
					tesoMovsConcilia.setInstitucionID(resultSet.getString(3));
					tesoMovsConcilia.setNumCtaInstit(resultSet.getString(4));
					tesoMovsConcilia.setFechaOperacion(resultSet.getString(5));
					tesoMovsConcilia.setNatMovimiento(resultSet.getString(6));
					tesoMovsConcilia.setMontoMov(resultSet.getString(7));
					tesoMovsConcilia.setTipoMov(resultSet.getString(8));
					tesoMovsConcilia.setDescripcionMov(resultSet.getString(9));
					tesoMovsConcilia.setReferenciaMov(resultSet.getString(10));
					tesoMovsConcilia.setStatus(resultSet.getString(11));
					return tesoMovsConcilia;
				}
			});
			listaMovs = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en listade movimientos no conciliados", e);
			return listaMovs;
		}
		return listaMovs;
	}

	// metodo para hacer el proceso de conciliacion manual
	public MensajeTransaccionBean tesoreriaConciliacionManual(final TesoMovsConciliaBean tesoMovsConciliaBean, final TesoMovsConciliaBean tesoMovsConcilia,
			final long poliza, final long numTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure

			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call TESOCONCIMANPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(tesoMovsConciliaBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit",tesoMovsConciliaBean.getNumCtaInstit());
									sentenciaStore.setLong("Par_FolioCargaID",Utileria.convierteLong(tesoMovsConcilia.getFolioCargaID()));
									sentenciaStore.setDate("Par_FechaOperacion",OperacionesFechas.conversionStrDate(tesoMovsConcilia.getFechaOperacion()));
									sentenciaStore.setString("Par_Descripcion",tesoMovsConcilia.getDescripcionMov());

									sentenciaStore.setString("Par_Referencia",tesoMovsConcilia.getReferenciaMov());
									sentenciaStore.setString("Par_Naturaleza",tesoMovsConcilia.getNatMovimiento());
									sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(tesoMovsConcilia.getMontoMov()));
									sentenciaStore.setString("Par_TipMovCon",tesoMovsConcilia.getTipoMov());
									sentenciaStore.setString("Par_CuentaConta",tesoMovsConcilia.getCuentaContable());
									sentenciaStore.setInt("Par_CentroCostos", Utileria.convierteEntero(tesoMovsConcilia.getcCostos())); // Centro de costos

									sentenciaStore.setLong("Par_PolizaID",poliza);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);
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
						mensajeBean.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						mensajeBean.setNombreControl(Constantes.STRING_VACIO);
						mensajeBean.setConsecutivoString(Constantes.STRING_CERO);

						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						mensajeBean.setNumero(mensajeBean.getNumero());
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
						mensajeBean.setNombreControl(mensajeBean.getNombreControl());
						mensajeBean.setConsecutivoString(mensajeBean.getConsecutivoString());
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion(e.getMessage());
					}else{
						mensajeBean.setDescripcion(mensajeBean.getDescripcion());
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en conciliacion manual de tesoreria", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean cierreMovs(final TesoMovsConciliaBean tesoBean, final ArrayList listaDetalleGrid){
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					ArrayList cierreConciliaciones = listaDetalleGrid;
					if(!cierreConciliaciones.isEmpty()){
						final int ActualizaConciliado = 1;
						for(int i=0;i<cierreConciliaciones.size();i++){
							final TesoMovsConciliaBean tesoMovsBean = (TesoMovsConciliaBean) cierreConciliaciones.get(i);
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator(){
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException{
											String query = "call TESORERIAMOVSACT(?,?,?,?,?,	?,?,?,?,?,	"
																			   + "?,?,?,?)";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_FolioMovimiento",Utileria.convierteEntero(tesoMovsBean.getNumeroMov()));
											sentenciaStore.setInt("Par_FolioCargaID",Constantes.ENTERO_CERO);
											sentenciaStore.setInt("Par_NumAct",ActualizaConciliado);

											sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
											sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
											sentenciaStore.setDouble("Par_Consecutivo", Constantes.ENTERO_CERO);

											sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.asignaChequesCaja");
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

											loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
											return sentenciaStore;
										}
									},new CallableStatementCallback() {
										public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																														DataAccessException{
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
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TesoMovsConciliaDAO.CierreMovs");
												mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
												mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
											}
											return mensajeTransaccion;
										}

									});
							if(mensajeBean == null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Conciliación de Movimientos Internos Cerrada Exitosamente");
						mensajeBean.setNombreControl("cuentaAhorroID");
						mensajeBean.setConsecutivoString("");
					}else{
						mensajeBean =new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No Se Encontraron Partidas para el Cierre de Movs. Internos");
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Cerrar los Movimientos Internos");
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

	public MensajeTransaccionBean cancelaConciliacionManual(final TesoMovsConciliaBean tesoBean){
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					ArrayList cierreConciliacionesManual = (ArrayList) hacerBeansConciliacionesManual(tesoBean);
					if(!cierreConciliacionesManual.isEmpty()){
						for(int i=0;i<cierreConciliacionesManual.size();i++){
							final TesoMovsConciliaBean tesoMovsBean = (TesoMovsConciliaBean) cierreConciliacionesManual.get(i);
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator(){
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException{
											String query = "call TESOMOVSCONCILIABAJ(?,?,?,?,?,	?,?,?,?,?,"
																			       +"?,?)";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setDouble("Par_FolioCarga",Utileria.convierteDoble(tesoMovsBean.getFolioCargaID()));
											sentenciaStore.setString("Par_Salida",Constantes.STRING_SI);
											sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
											sentenciaStore.setDouble("Par_Consecutivo", Constantes.ENTERO_CERO);

											sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID","CuentaNostroDAO.asignaChequesCaja");
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

											loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
											return sentenciaStore;
										}
									},new CallableStatementCallback() {
										public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																														DataAccessException{
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
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TesoMovsConciliaDAO.CancelaConciliacionesManual");
												mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
												mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
											}
											return mensajeTransaccion;
										}

									});
							if(mensajeBean == null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Movimientos de Conciliación Cancelados Exitosamente");
						mensajeBean.setNombreControl("numCtaInstit");
						mensajeBean.setConsecutivoString("");
					}else{
						mensajeBean =new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No Se Encontraron Partidas para la cancelacion de Movs. de conciliacion");
					}
				}catch(Exception e){
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Cerrar los Movimientos de conciliacion");
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


	public MensajeTransaccionBean guardaConciliacion(final TesoMovsConciliaBean tesoConcilia){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
				resultadoBean.setNumero(0);
				TesoMovsConciliaBean tesoMovsConciliaBean =null;
				PolizaBean polizaBean = new PolizaBean();
				int numeroPoliza = 0;
				int polizaGenerada = 1;
				ArrayList listaMovimientos = (ArrayList) listaGridMovimientos(tesoConcilia);

				try{
					if(resultadoBean.getNumero()==0){
						if(!listaMovimientos.isEmpty()){
							for(int i=0; i < listaMovimientos.size(); i++){
								tesoMovsConciliaBean = (TesoMovsConciliaBean) listaMovimientos.get(i);

								if(tesoMovsConciliaBean.getTipoMov().isEmpty()){

								}else{
									if(polizaGenerada==1 ){
										polizaBean.setConceptoID(conceptoConManualID);

										if(tesoConcilia.getExistenMovsSelec() > 1){
											polizaBean.setConcepto(conceptoConManualDes);
											}else{
											polizaBean.setConcepto(tesoConcilia.getTipoMovTesoDes());
											}

										polizaBean.setTipo(automatico);
										polizaBean.setFecha(tesoMovsConciliaBean.getFechaOperacion());

										int contador = 0;
										while(contador <= PolizaBean.numIntentosGeneraPoliza){
											contador ++;
											polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
											if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
												break;
											}
										}

										// se manda a llamar el alta de la poliza
										/*resultadoBean = polizaDAO.altaPoliza(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());*/

										polizaGenerada =0;
									}
									numeroPoliza= Integer.parseInt(polizaBean.getPolizaID());

									if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0) {

										resultadoBean= tesoreriaConciliacionManual(tesoConcilia, tesoMovsConciliaBean, numeroPoliza, parametrosAuditoriaBean.getNumeroTransaccion());

										if(resultadoBean.getNumero()!=0){
											MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
											mensaje = resultadoBean;
											try{
												// Baja de Poliza en caso de que haya ocurrido un error
												PolizaBean bajaPolizaBean = new PolizaBean();
												bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
												bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
												bajaPolizaBean.setNumErrPol(resultadoBean.getNumero() + "");
												bajaPolizaBean.setErrMenPol(resultadoBean.getDescripcion());
												bajaPolizaBean.setDescProceso("TesoMovsConciliaServicio.guardaConciliacion");
												bajaPolizaBean.setPolizaID(polizaBean.getPolizaID());
												MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
												mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
												loggerSAFI.error(" Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());

											} catch (Exception ex) {
												ex.printStackTrace();
												throw new Exception(resultadoBean.getDescripcion());
											}
										}
									} else{
										resultadoBean.setNumero(999);
										resultadoBean.setDescripcion("El Número de Póliza se encuentra Vacio.");
										resultadoBean.setNombreControl("numeroTransaccion");
										resultadoBean.setConsecutivoString("0");
									 	}
								}
								if(resultadoBean.getNumero()!=0){

									throw new Exception(resultadoBean.getDescripcion());
								}
							}
						}else{
							resultadoBean.setNumero(999);
							resultadoBean.setDescripcion("No hay movimientos para los datos proporcionados");
							resultadoBean.setNombreControl(Constantes.STRING_VACIO);
							resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
							throw new Exception("No hay movimientos para los datos proporcionados");
						}

					}else{
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(resultadoBean.getDescripcion());
						resultadoBean.setNombreControl(resultadoBean.getNombreControl());
						resultadoBean.setConsecutivoString(resultadoBean.getConsecutivoString());
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}


				}catch(Exception e){
					if (resultadoBean.getNumero() == 0) {
						resultadoBean.setNumero(999);
					}
					resultadoBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en conciliación manual", e);
				}
			return resultadoBean;
			}
		});
		return resultado;
	}


	public List listaGridMovimientos(TesoMovsConciliaBean tesoMovsConciliaBean){

		List<String> listaFolioCargaID   = tesoMovsConciliaBean.getListaFolioCargaID();
		List<String> listaFechaOperacion   = tesoMovsConciliaBean.getListaFechaOperacion();
		List<String> listaDescripcionMov   = tesoMovsConciliaBean.getListaDescripcionMov();
		List<String> listaReferenciaMov   = tesoMovsConciliaBean.getListaReferenciaMov();
		List<String> listaNatMovimiento   = tesoMovsConciliaBean.getListaNatMovimiento();

		List<String> listaMontoMov   = tesoMovsConciliaBean.getListaMontoMov();
		List<String> listaTipoMov   	   = tesoMovsConciliaBean.getListaTipoMov();
		List<String> listaCuentaContable   = tesoMovsConciliaBean.getListaCuentaContable();
		List<String> listaCentroCosto	= tesoMovsConciliaBean.getListaCentroCosto(); // centron de costos

		ArrayList listaDetalle = new ArrayList();
		TesoMovsConciliaBean tesoMovsConcilia = null;
		try{
			if(!listaFolioCargaID.isEmpty()){
				int tamanio = listaFolioCargaID.size();


				for(int i=0; i<tamanio; i++){
					tesoMovsConcilia = new TesoMovsConciliaBean();

					tesoMovsConcilia.setFolioCargaID(listaFolioCargaID.get(i));
					tesoMovsConcilia.setFechaOperacion(listaFechaOperacion.get(i));
					tesoMovsConcilia.setDescripcionMov(listaDescripcionMov.get(i));
					tesoMovsConcilia.setReferenciaMov(listaReferenciaMov.get(i));
					tesoMovsConcilia.setNatMovimiento(listaNatMovimiento.get(i));

					tesoMovsConcilia.setMontoMov(listaMontoMov.get(i).trim().replaceAll(",",""));
					tesoMovsConcilia.setTipoMov(listaTipoMov.get(i));
					tesoMovsConcilia.setCuentaContable(listaCuentaContable.get(i));
					tesoMovsConcilia.setcCostos(listaCentroCosto.get(i));

					listaDetalle.add(tesoMovsConcilia);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de grid de movimientos", e);
		}
		return listaDetalle;
	}

	public List listaConsultaMovs(TesoMovsConciliaBean tesoMovsConcilia, int tipoConsulta){
		List listaConsulta = null ;
		try{
			String query = "call TESCONCILIAMOVSCON(?,?,?, ?,?,?,?,?,?,?);";

			Object[] parametros ={
					Utileria.convierteEntero(tesoMovsConcilia.getInstitucionID()),
					tesoMovsConcilia.getNumCtaInstit(),
			  		tipoConsulta,

			  		Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaConsultaMovs",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TESCONCILIAMOVSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TesoMovsConciliaBean tesoMovsConciliaBean = new TesoMovsConciliaBean();

					// Datos de la tabla TESORERIAMOVS
					tesoMovsConciliaBean.setListaFoliosMovs(resultSet.getString("FolioMovimiento"));

					return  tesoMovsConciliaBean;
				}

			});

			listaConsulta= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de consulta de movimientos ", e);
		}
		return listaConsulta;
	}

	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List hacerBeansConciliacionesManual(TesoMovsConciliaBean tesoMovsBean){
		String FoliosCarga [] = tesoMovsBean.getListaFoliosCarga().split(",");

		ArrayList beansConcilia =  new ArrayList();
		if(FoliosCarga[0]!=""){
			for(int i=0; i<FoliosCarga.length;i++){
				TesoMovsConciliaBean tesoBean = new TesoMovsConciliaBean();
				tesoBean.setFolioCargaID(FoliosCarga[i]);
				beansConcilia.add(tesoBean);
			}
		}
		return beansConcilia;
	}

	public long generaUnicoTransaccion(){
		return transaccionDAO.generaNumeroTransaccionOut();
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}


}