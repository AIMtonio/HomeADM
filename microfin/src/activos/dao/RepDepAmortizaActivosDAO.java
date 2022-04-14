package activos.dao;

import org.springframework.jdbc.core.JdbcTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import activos.bean.RepDepAmortizaActivosBean;
import activos.servicio.RepDepAmortizaActivosServicio.Enum_Rep_DepAmortizaActivos;

public class RepDepAmortizaActivosDAO extends BaseDAO{

	public RepDepAmortizaActivosDAO() {
		super();
	}

	// Depreciacion y Amortizacion de Activos
	public List<RepDepAmortizaActivosBean> reporteDepAmortizaActivos(int tipoReporte, final RepDepAmortizaActivosBean repDepAmortizaActivosBean){
		List<RepDepAmortizaActivosBean> ListaResultado = null;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String nombrePrograma = Constantes.STRING_VACIO;

			switch(tipoReporte){
				case Enum_Rep_DepAmortizaActivos.reporteContable:
					nombrePrograma = "reporteDepAmortizaActivos.ReporteDepAmortizaConta";
				break;
				case Enum_Rep_DepAmortizaActivos.reporteFiscal:
					nombrePrograma = "reporteDepAmortizaActivos.ReporteDepAmortizaFis";
				break;
				case Enum_Rep_DepAmortizaActivos.reporteAmbos:
					nombrePrograma = "reporteDepAmortizaActivos.ReporteDepAmortiza";
				break;
				default:
					nombrePrograma = "reporteDepAmortizaActivos.ReporteDepAmortiza";
				break;
			}

			String query = "CALL DEPAMORTIZAACTIVOSREP(?,?,?,?,?, " +
													  "?," +
													  "?," +
													  "?,?,?,?,?,?,?)";

			Object[] parametros ={
				Utileria.convierteFecha(repDepAmortizaActivosBean.getFechaInicio()),
				Utileria.convierteFecha(repDepAmortizaActivosBean.getFechaFin()),
				Utileria.convierteEntero(repDepAmortizaActivosBean.getCentroCosto()),
				Utileria.convierteEntero(repDepAmortizaActivosBean.getTipoActivo()),
				Utileria.convierteEntero(repDepAmortizaActivosBean.getClasificacion()),

				repDepAmortizaActivosBean.getEstatus(),
				tipoReporte,

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				nombrePrograma,
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL DEPAMORTIZAACTIVOSREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepDepAmortizaActivosBean repDepAmortizaActivosBean= new RepDepAmortizaActivosBean();

					repDepAmortizaActivosBean.setDescTipoActivo(resultSet.getString("DescTipoActivo"));
					repDepAmortizaActivosBean.setDescActivo(resultSet.getString("DescActivo"));
					repDepAmortizaActivosBean.setFechaAdquisicion(resultSet.getString("FechaAdquisicion"));
					repDepAmortizaActivosBean.setNumFactura(resultSet.getString("NumFactura"));
					repDepAmortizaActivosBean.setPoliza(resultSet.getString("Poliza"));

					repDepAmortizaActivosBean.setDescCentroCosto(resultSet.getString("CentroCosto"));
					repDepAmortizaActivosBean.setMoi(resultSet.getString("Moi"));
					repDepAmortizaActivosBean.setInpcInicial(resultSet.getString("InpcInicial"));
					repDepAmortizaActivosBean.setInpcActual(resultSet.getString("InpcActual"));
					repDepAmortizaActivosBean.setFactorActualizacion(resultSet.getString("FactorActualizacion"));

					repDepAmortizaActivosBean.setPorDepreContaAnual(resultSet.getString("PorDepreContaAnual"));
					repDepAmortizaActivosBean.setDepreciaContaAnual(resultSet.getString("DepreciaContaAnual"));
					repDepAmortizaActivosBean.setTiempoAmortiMeses(resultSet.getString("TiempoAmortiMeses"));
					repDepAmortizaActivosBean.setPorDepreFiscalAnual(resultSet.getString("PorDepreFiscalAnual"));
					repDepAmortizaActivosBean.setDepreciaFiscalAnual(resultSet.getString("DepreciaFiscalAnual"));

					repDepAmortizaActivosBean.setColumnasAnio(resultSet.getString("ColumnasAnio"));
					repDepAmortizaActivosBean.setEnero(resultSet.getString("Enero"));

					repDepAmortizaActivosBean.setFebrero(resultSet.getString("Febrero"));
					repDepAmortizaActivosBean.setMarzo(resultSet.getString("Marzo"));
					repDepAmortizaActivosBean.setAbril(resultSet.getString("Abril"));
					repDepAmortizaActivosBean.setMayo(resultSet.getString("Mayo"));
					repDepAmortizaActivosBean.setJunio(resultSet.getString("Junio"));

					repDepAmortizaActivosBean.setJulio(resultSet.getString("Julio"));
					repDepAmortizaActivosBean.setAgosto(resultSet.getString("Agosto"));
					repDepAmortizaActivosBean.setSeptiembre(resultSet.getString("Septiembre"));
					repDepAmortizaActivosBean.setOctubre(resultSet.getString("Octubre"));
					repDepAmortizaActivosBean.setNoviembre(resultSet.getString("Noviembre"));

					repDepAmortizaActivosBean.setDiciembre(resultSet.getString("Diciembre"));
					repDepAmortizaActivosBean.setDepreciadoAcumulado(resultSet.getString("DepreciadoAcumulado"));
					repDepAmortizaActivosBean.setSaldoPorDepreciar(resultSet.getString("SaldoPorDepreciar"));
					repDepAmortizaActivosBean.setDepFiscalSaldoInicial(resultSet.getString("DepFiscalSaldoInicial"));
					repDepAmortizaActivosBean.setDepFiscalSaldoFinal(resultSet.getString("DepFiscalSaldoFinal"));

					repDepAmortizaActivosBean.setActivoID(resultSet.getString("ActivoID"));
					repDepAmortizaActivosBean.setTipoActivo(resultSet.getString("TipoActivoID"));
					repDepAmortizaActivosBean.setColumnas(resultSet.getString("Columnas"));
					repDepAmortizaActivosBean.setTipoFila(resultSet.getString("TipoFila"));

					return repDepAmortizaActivosBean ;
				}
			});
			ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el reporte de depreciación y amortización activos ", e);
		}
		return ListaResultado;
	}
}

