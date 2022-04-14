package activos.dao;

import org.springframework.jdbc.core.JdbcTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import org.springframework.jdbc.core.RowMapper;

import activos.bean.RepCatalogoActivosBean;

public class RepCatalogoActivosDAO extends BaseDAO{
		
	public RepCatalogoActivosDAO() {
		super();
	}

	// Catalogo de Activos Detallados en Excel
	public List reporteCatalogoActivos(int tipoLista, final RepCatalogoActivosBean repCatalogoActivosBean){	
		List ListaResultado=null;
		try{
			String query = "call CATALOGOACTIVOSREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?)";
	
			Object[] parametros ={
					Utileria.convierteFecha(repCatalogoActivosBean.getFechaInicio()),
					Utileria.convierteFecha(repCatalogoActivosBean.getFechaFin()),
					Utileria.convierteEntero(repCatalogoActivosBean.getCentroCosto()),
					Utileria.convierteEntero(repCatalogoActivosBean.getTipoActivo()),
					Utileria.convierteEntero(repCatalogoActivosBean.getClasificacion()),
					repCatalogoActivosBean.getEstatus(),
							
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"reporteCatalogoActivosExcel",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOACTIVOSREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepCatalogoActivosBean repCatalogoActivosBean= new RepCatalogoActivosBean();
									
					repCatalogoActivosBean.setDescTipoActivo(resultSet.getString("DescTipoActivo"));
					repCatalogoActivosBean.setDescActivo(resultSet.getString("DescActivo"));
					repCatalogoActivosBean.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					repCatalogoActivosBean.setNumFactura(resultSet.getString("NumFactura"));
					repCatalogoActivosBean.setPolizaFactura(resultSet.getString("PolizaFactura"));
					
					repCatalogoActivosBean.setCentroCostoID(resultSet.getString("CentroCostoID"));
					repCatalogoActivosBean.setClasificacion(resultSet.getString("Clasificacion"));
					repCatalogoActivosBean.setMoi(resultSet.getString("Moi"));
					repCatalogoActivosBean.setEstatus(resultSet.getString("Estatus"));
					
					// Seccion Contabla
					repCatalogoActivosBean.setDepreciacionAnual(resultSet.getString("DepreciacionAnual"));
					repCatalogoActivosBean.setTiempoAmortiMeses(resultSet.getString("TiempoAmortiMeses"));
					repCatalogoActivosBean.setDepreContaAnual(resultSet.getString("DepreContaAnual"));
					repCatalogoActivosBean.setDepreciadoAcumulado(resultSet.getString("DepreciadoAcumulado"));
					repCatalogoActivosBean.setTotalDepreciar(resultSet.getString("TotalDepreciar"));
					
					// Seccion Fiscal
					repCatalogoActivosBean.setDepreciacionAnualFiscal(resultSet.getString("DepreciacionAnualFiscal"));
					repCatalogoActivosBean.setTiempoAmortiMesesFiscal(resultSet.getString("TiempoAmortiMesesFiscal"));
					repCatalogoActivosBean.setDepreFiscalAnual(resultSet.getString("DepreFiscalAnual"));
					repCatalogoActivosBean.setDepreciadoAcumuladoFiscal(resultSet.getString("DepreciadoAcumuladoFiscal"));
					repCatalogoActivosBean.setSaldoDepreciarFiscal(resultSet.getString("SaldoDepreciarFiscal"));
					repCatalogoActivosBean.setTipoRegistro(resultSet.getString("TipoRegistro"));
					return repCatalogoActivosBean ;
				}
			});
			ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de catalogo de activos", e);
		}
		return ListaResultado;
	}

}

