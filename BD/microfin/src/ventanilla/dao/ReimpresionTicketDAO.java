package ventanilla.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import ventanilla.bean.ReimpresionTicketBean;
import ventanilla.servicio.ReimpresionTicketServicio.Enum_Ticket_Ventanilla;

public class ReimpresionTicketDAO extends BaseDAO{
	
	public ReimpresionTicketDAO(){
		super();
	}
	 
	public List listaReimpresionTicket(int tipoLista, ReimpresionTicketBean reimpresionBean){
		List listaReimpresiones = null;
		try{
			String query = "call REIMPRESIONTICKETLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
			Object[] parametros = {
					reimpresionBean.getTipoOpera(),
					Constantes.ENTERO_CERO,
					reimpresionBean.getNumTransaccion(),					
					tipoLista,

					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getUsuario(),
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"listaReimpresionTicket",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REIMPRESIONTICKETLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {		
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReimpresionTicketBean reimpresionBean = new ReimpresionTicketBean();
					
					reimpresionBean.setTransaccionID(resultSet.getString("TransaccionID"));
					reimpresionBean.setReferencia(resultSet.getString("Referencia"));
					reimpresionBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
					reimpresionBean.setNombrePersona(resultSet.getString("NombrePersona"));					
					
					return reimpresionBean;
				}
			});
			listaReimpresiones = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la lista de Reimpresiones de Ticket");
		}
		return listaReimpresiones;
	}
	
	public List consultaGrid(int tipoLista, ReimpresionTicketBean reimpreBean){
		List listaReimpresiones = null;
		try{
			String query = "call REIMPRESIONTICKETLIS(?,?,?,?,?,	?,?,?,?,?,	?);";
			Object[] parametros = {
					reimpreBean.getTipoOpera(),
					reimpreBean.getNumTransaccion(),
					reimpreBean.getNombrePersona(),
					tipoLista,

					Constantes.ENTERO_CERO,
					parametrosAuditoriaBean.getUsuario(),
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"listaReimpresionTicket",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REIMPRESIONTICKETLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {		
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReimpresionTicketBean reimpresionBean = new ReimpresionTicketBean();
					
					reimpresionBean.setTransaccionID(resultSet.getString("TransaccionID"));
					reimpresionBean.setTipoOpera(resultSet.getString("TipoOperacionID"));
					reimpresionBean.setSucursalID(resultSet.getString("SucursalID"));
					reimpresionBean.setCajaID(resultSet.getString("CajaID"));
					reimpresionBean.setUsuarioID(resultSet.getString("UsuarioID"));
					
					reimpresionBean.setFecha(resultSet.getString("Fecha"));
					reimpresionBean.setHora(resultSet.getString("Hora"));
					reimpresionBean.setOpcionCajaID(resultSet.getString("OpcionCajaID"));
					reimpresionBean.setDescripcion(resultSet.getString("Descripcion"));
					reimpresionBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
					
					reimpresionBean.setEfectivo(resultSet.getString("Efectivo"));
					reimpresionBean.setCambio(resultSet.getString("Cambio"));
					reimpresionBean.setNombrePersona(resultSet.getString("NombrePersona"));
					reimpresionBean.setNombreBeneficiario(resultSet.getString("NombreBeneficiario"));
					reimpresionBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),10));
					
					reimpresionBean.setProspectoID(Utileria.completaCerosIzquierda(resultSet.getString("ProspectoID"),10));
					reimpresionBean.setEmpleadoID(resultSet.getString("EmpleadoID"));
					reimpresionBean.setNombreEmpleado(resultSet.getString("NombreEmpleado"));
					reimpresionBean.setCuentaIDRetiro(Utileria.completaCerosIzquierda(resultSet.getString("CuentaIDRetiro"),11));					
					reimpresionBean.setCuentaIDDeposito(resultSet.getString("CuentaIDDeposito"));
					
					reimpresionBean.setEtiquetaCtaRetiro(resultSet.getString("EtiquetaCtaRetiro"));
					reimpresionBean.setEtiquetaCtaDepo(resultSet.getString("EtiquetaCtaDepo"));					
					reimpresionBean.setDesTipoCuenta(resultSet.getString("DesTipoCuenta"));
					reimpresionBean.setDesTipoCtaDepo(resultSet.getString("DesTipoCtaDepo"));
					reimpresionBean.setSaldoActualCta(resultSet.getString("SaldoActualCta"));
					
					reimpresionBean.setReferencia(resultSet.getString("Referencia"));
					reimpresionBean.setFormaPagoCobro(resultSet.getString("FormaPagoCobro"));					
					reimpresionBean.setCreditoID(resultSet.getString("CreditoID"));
					reimpresionBean.setProducCreditoID(resultSet.getString("ProducCreditoID"));
					reimpresionBean.setNombreProdCred(resultSet.getString("NombreProdCred"));
					
					reimpresionBean.setMontoCredito(resultSet.getString("MontoCredito"));
					reimpresionBean.setMontoPorDesem(resultSet.getString("MontoPorDesem"));
					reimpresionBean.setMontoDesemb(resultSet.getString("MontoDesemb"));
					reimpresionBean.setGrupoID(resultSet.getString("GrupoID"));
					reimpresionBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					
					reimpresionBean.setCicloActual(resultSet.getString("CicloActual"));
					reimpresionBean.setMontoProximoPago(resultSet.getString("MontoProximoPago"));					
					reimpresionBean.setFechaProximoPago(resultSet.getString("FechaProximoPago"));					
					reimpresionBean.setTotalAdeudo(resultSet.getString("TotalAdeudo"));
					reimpresionBean.setCapital(resultSet.getString("Capital"));
					
					reimpresionBean.setInteres(resultSet.getString("Interes"));
					reimpresionBean.setMoratorios(resultSet.getString("Moratorios"));					
					reimpresionBean.setComision(resultSet.getString("Comision"));					
					reimpresionBean.setComisionAdmon(resultSet.getString("ComisionAdmon"));
					reimpresionBean.setiVA(resultSet.getString("IVA"));
					
					reimpresionBean.setGarantiaAdicional(resultSet.getString("GarantiaAdicional"));
					reimpresionBean.setInstitucionID(resultSet.getString("InstitucionID"));					
					reimpresionBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));					
					reimpresionBean.setNumCheque(resultSet.getString("NumCheque"));
					reimpresionBean.setNombreInstitucion(resultSet.getString("NombreInstit"));
					
					reimpresionBean.setPolizaID(resultSet.getString("PolizaID"));
					reimpresionBean.setTelefono(resultSet.getString("Telefono"));			
					reimpresionBean.setIdentificacion(resultSet.getString("Identificacion"));					
					reimpresionBean.setFolioIdentificacion(resultSet.getString("FolioIdentificacion"));					
					reimpresionBean.setFolioPago(resultSet.getString("FolioPago"));
					
					reimpresionBean.setCatalogoServID(resultSet.getString("CatalogoServID"));
					reimpresionBean.setNombreCatalServ(resultSet.getString("NombreCatalServ"));					
					reimpresionBean.setMontoServicio(resultSet.getString("MontoServicio"));
					reimpresionBean.setiVAServicio(resultSet.getString("IVAServicio"));
					reimpresionBean.setOrigenServicio(resultSet.getString("OrigenServicio"));
					
					reimpresionBean.setMontoComision(resultSet.getString("MontoComision"));
					reimpresionBean.setTotalCastigado(resultSet.getString("TotalCastigado"));
					reimpresionBean.setTotalRecuperado(resultSet.getString("TotalRecuperado"));					
					reimpresionBean.setMonto_PorRecuperar(resultSet.getString("Monto_PorRecuperar"));
					reimpresionBean.setTipoServServifun(resultSet.getString("TipoServServifun"));
					//SEGUROS
					reimpresionBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
					reimpresionBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
					reimpresionBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
					
					//Arrendamiento
					reimpresionBean.setArrendaID(resultSet.getString("ArrendaID"));
					reimpresionBean.setProdArrendaID(resultSet.getString("ProdArrendaID"));
					reimpresionBean.setNomProdArrendaID(resultSet.getString("NomProdArrendaID"));
					reimpresionBean.setSeguroVida(resultSet.getString("SeguroVida"));
					reimpresionBean.setSeguro(resultSet.getString("Seguro"));
					reimpresionBean.setiVASeguroVida(resultSet.getString("IVASeguroVida"));
					reimpresionBean.setiVASeguro(resultSet.getString("IVASeguro"));
					reimpresionBean.setiVACapital(resultSet.getString("IVACapital"));
					reimpresionBean.setiVAInteres(resultSet.getString("IVAInteres"));
					reimpresionBean.setiVAMora(resultSet.getString("IVAMora"));
					reimpresionBean.setiVAOtrasComi(resultSet.getString("IVAOtrasComi"));
					reimpresionBean.setiVAComFaltaPag(resultSet.getString("IVAComFaltaPag"));
					
					reimpresionBean.setAccesorioID(resultSet.getString("AccesorioID"));

					return reimpresionBean;
				}
			});
			listaReimpresiones = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grid de Reimpresiones de Ticket");
		}
		return listaReimpresiones;
	}
	
	/**
	 * M&eacute;todo para consultar los datos para la Reimpresion de tickets de la ventanilla.
	 * @param reimpresion : {@link ReimpresionTicketBean} Bean con el n&uacute;mero de transacci&oacute;n a consultar.
	 * @param tipoConsulta : Tipo de Operaci&oacute;n de Ventanilla.
	 * @return {@link ReimpresionTicketBean}
	 */
	public ReimpresionTicketBean consultaPrincipal(ReimpresionTicketBean reimpresion, final int tipoConsulta) {
		ReimpresionTicketBean consultaBean = null;
		try {
			//Query con el Store Procedure
			String query = "call REIMPTICKETCON(" + "?,?,?,?,?," + "?,?,?,?,?);";
			Object[] parametros = {reimpresion.getTransaccionID(), reimpresion.getCreditoID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO,
			
			Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "ReimpresionTicketDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			
			loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call REIMPTICKETCON(" + Arrays.toString(parametros) + ")");
			List<ReimpresionTicketBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReimpresionTicketBean reimpresionTicketBean = new ReimpresionTicketBean();
					switch (tipoConsulta) {
						case Enum_Ticket_Ventanilla.cargoCuenta :
						case Enum_Ticket_Ventanilla.abonoCuenta :
						case Enum_Ticket_Ventanilla.rev_cargoCuenta :
						case Enum_Ticket_Ventanilla.rev_abonoCuenta :
							reimpresionTicketBean.setTransaccionID(resultSet.getString("TransaccionID"));
							reimpresionTicketBean.setTipoOpera(resultSet.getString("TipoOperacionID"));
							reimpresionTicketBean.setSucursalID(resultSet.getString("SucursalID"));
							reimpresionTicketBean.setCajaID(resultSet.getString("CajaID"));
							reimpresionTicketBean.setUsuarioID(resultSet.getString("UsuarioID"));
							reimpresionTicketBean.setClave(resultSet.getString("Clave"));
							reimpresionTicketBean.setFecha(resultSet.getString("Fecha"));
							reimpresionTicketBean.setHora(resultSet.getString("Hora"));
							reimpresionTicketBean.setOpcionCajaID(resultSet.getString("OpcionCajaID"));
							reimpresionTicketBean.setDescripcion(resultSet.getString("Descripcion"));
							reimpresionTicketBean.setMontoOperacion(resultSet.getString("MontoOperacion"));
							reimpresionTicketBean.setEfectivo(resultSet.getString("Efectivo"));
							reimpresionTicketBean.setCambio(resultSet.getString("Cambio"));
							reimpresionTicketBean.setNombrePersona(resultSet.getString("NombrePersona"));
							reimpresionTicketBean.setClienteID(resultSet.getString("ClienteID"));
							reimpresionTicketBean.setCuentaIDDeposito(resultSet.getString("CuentaIDDeposito"));
							reimpresionTicketBean.setCuentaIDRetiro(resultSet.getString("CuentaIDRetiro"));
							reimpresionTicketBean.setEtiquetaCtaDepo(resultSet.getString("EtiquetaCtaDepo"));
							reimpresionTicketBean.setEtiquetaCtaRetiro(resultSet.getString("EtiquetaCtaRetiro"));
							reimpresionTicketBean.setSaldoActualCta(resultSet.getString("SaldoActualCta"));
							reimpresionTicketBean.setReferencia(resultSet.getString("Referencia"));
							reimpresionTicketBean.setTipoCuenta(resultSet.getString("TipoCuenta"));
							reimpresionTicketBean.setSaldoInicial(resultSet.getString("SaldoInicial"));
							reimpresionTicketBean.setMoneda(resultSet.getString("Moneda"));
							reimpresionTicketBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
							reimpresionTicketBean.setReferencia(resultSet.getString("Referencia"));
							reimpresionTicketBean.setFormaPagoCobro(resultSet.getString("FormaPagoCobro"));
							break;
					}
					
					return reimpresionTicketBean;
				}
			});
			consultaBean = matches.size() > 0 ? (ReimpresionTicketBean) matches.get(0) : null;
			
		} catch (Exception e) {
			e.printStackTrace();
			loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Consulta de Reimpresion de Ticket", e);
		}
		return consultaBean;
	}
	
	
}

