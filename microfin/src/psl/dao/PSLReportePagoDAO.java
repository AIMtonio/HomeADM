package psl.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import psl.bean.PSLReportePagoBean;


public class PSLReportePagoDAO extends BaseDAO {
	public List<PSLReportePagoBean> reportePagoServicios(int numeroReporte, final PSLReportePagoBean pslReportePagoBean){
		List<PSLReportePagoBean> resultado = null;

		try {
			String query="CALL PSLCOBROSLREP(	?,?,?,?,?,	?,?,?,?,?," +
												"?,?,?,?,?,	?,?,?,?,?," +
												"?,?)";
			Object[] parametros={
					pslReportePagoBean.getProductoID(),
					pslReportePagoBean.getServicioID(),
					pslReportePagoBean.getTipoServicioID(),
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					Constantes.FECHA_VACIA,
					pslReportePagoBean.getSucursalID(),
					Constantes.ENTERO_CERO,

					Constantes.ENTERO_CERO,
					pslReportePagoBean.getCanal(),
					pslReportePagoBean.getFechaInicio(),
					pslReportePagoBean.getFechaFin(),
					numeroReporte,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"PSLReportePagoDAO.reportePagoServicios",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PSLCOBROSLREP("+ Arrays.toString(parametros)+")");
			List<PSLReportePagoBean> matches=((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					PSLReportePagoBean reportePagoBean = new PSLReportePagoBean();
					reportePagoBean.setCobroID(resultSet.getString("CobroID"));
					reportePagoBean.setFechaPago(resultSet.getString("FechaHora"));
					reportePagoBean.setNumeroCaja(resultSet.getString("CajaID"));
					reportePagoBean.setProducto(resultSet.getString("Producto"));
					reportePagoBean.setTelefono(resultSet.getString("Telefono"));
					reportePagoBean.setReferencia(resultSet.getString("Referencia"));
					reportePagoBean.setMontoServicio(resultSet.getString("Precio"));
					reportePagoBean.setMontoComisionProveedor(resultSet.getString("ComisiProveedor"));
					reportePagoBean.setMontoComisionInstitucion(resultSet.getString("ComisiInstitucion"));
					reportePagoBean.setIvaComisionInstitucion(resultSet.getString("IVAComision"));
					reportePagoBean.setTotalPagado(resultSet.getString("TotalPagar"));
					reportePagoBean.setTipoServicioID(resultSet.getString("ClasificacionServ"));
					reportePagoBean.setServicioID(resultSet.getString("ServicioID"));
					reportePagoBean.setProductoID(resultSet.getString("ProductoID"));
					reportePagoBean.setSucursalID(resultSet.getString("SucursalID"));
					reportePagoBean.setSucursal(resultSet.getString("NombreSucurs"));
					reportePagoBean.setServicio(resultSet.getString("Servicio"));
					reportePagoBean.setFormaPago(resultSet.getString("FormaPago"));
					reportePagoBean.setCanal(resultSet.getString("Canal"));

					return reportePagoBean;
				}
			});
			resultado = matches.size() > 0 ? matches : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de reporte de pago de servicios", e);
		}
		return resultado;
	}
}
