<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" indent="no" />
  <xsl:strip-space elements="*" />
  <xsl:variable name="nl"><xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:template match="/RftgExport">
    <xsl:apply-templates select="Log" />
    <xsl:apply-templates select="Setup/Variant" />
    <xsl:apply-templates select="Status" mode="statusHeader" />
    <xsl:apply-templates select="Player" />
    <xsl:value-of select="$nl" />
    <xsl:apply-templates select="Status" mode="statusFooter" />
  </xsl:template>

  <xsl:template match="Setup/Variant">
    <xsl:value-of select="concat('Variant game: ', ., $nl)" />
  </xsl:template>

  <xsl:template match="Tampered" mode="statusHeader" />

  <xsl:template match="Round" mode="statusHeader">
    <xsl:if test="not(../GameOver)"><xsl:value-of select="concat('Round ', ., $nl)" /></xsl:if>
  </xsl:template>

  <xsl:template match="GameOver" mode="statusHeader">
    <xsl:text>[b]Game has ended[/b]</xsl:text>
    <xsl:value-of select="$nl" />
    <xsl:apply-templates select="../../Player" mode="winner" /><br />
  </xsl:template>

  <xsl:template match="Phase">
    <b>
      <xsl:if test="@current = 'yes'">
        <xsl:attribute name="style">color:blue</xsl:attribute>
      </xsl:if>
      <xsl:value-of select="." />
    </b>
    <xsl:if test="position() != last()"> - </xsl:if>
  </xsl:template>

  <xsl:template match="Phase">
    <xsl:choose>
      <xsl:when test="@current = 'yes'">
        <xsl:value-of select="concat('[b][color=blue]', ., '[/color][/b]')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('[b]', ., '[/b]')" />
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="position() != last()"> - </xsl:if>
  </xsl:template>

  <xsl:template match="Phases" mode="statusHeader">
    <xsl:if test="not(../GameOver)">
      <xsl:text>Round phases: </xsl:text>
      <xsl:apply-templates select="Phase" />
      <xsl:value-of select="$nl" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="Deck" mode="statusHeader">
    <xsl:text>Draw deck size: [b]</xsl:text>
    <xsl:value-of select="." /> card<xsl:if test=". != 1">s</xsl:if>
    <xsl:text>[/b] - </xsl:text>
  </xsl:template>

  <xsl:template match="Discard" mode="statusHeader">
    <xsl:text>Discard pile size: [b]</xsl:text>
    <xsl:value-of select="." /> card<xsl:if test=". != 1">s</xsl:if>
    <xsl:text>[/b] - </xsl:text>
  </xsl:template>

  <xsl:template match="Pool" mode="statusHeader">
    <xsl:text>VP chips left: [b]</xsl:text>
    <xsl:value-of select="." /> chip<xsl:if test=". != 1">s</xsl:if>
    <xsl:text>[/b]</xsl:text>
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Goals" mode="statusHeader">
    <xsl:text>Goals: </xsl:text>
    <xsl:if test="count(Goal) = 0">None</xsl:if>
    <xsl:apply-templates select="Goal" mode="names" />
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Player" mode="winner">
    <xsl:if test="./@winner"><xsl:value-of select="concat('[b]', Name, ' wins the game[/b]', $nl)" /></xsl:if>
  </xsl:template>

  <xsl:template match="Player">
    <xsl:value-of select="$nl" />
    <xsl:apply-templates select="Name | Actions | Deck | Discard" mode="player" />
    <xsl:apply-templates select="Prestige" mode="player" />
    <xsl:apply-templates select="Hand" mode="player" />
    <xsl:apply-templates select="Chips | Score | Goals | Tableau | Saved" mode="player" />
    <xsl:apply-templates select="Hand | Start | Search | Discards | Flips" mode="hand" />
  </xsl:template>

  <xsl:template match="Name" mode="player">
    <xsl:text>[b][size=14]</xsl:text><xsl:if test="../@ai and not(starts-with(., '[AI]'))">[AI] </xsl:if><xsl:value-of select="concat(., '[/size][/b]', $nl)" />
  </xsl:template>

  <xsl:template match="Action">
    <xsl:value-of select="concat('[b]', ., '[/b]')" />
    <xsl:if test="position() != last()"> - </xsl:if>
  </xsl:template>

  <xsl:template match="Actions" mode="player">
    <xsl:text>Action</xsl:text><xsl:if test="/RftgExport/Setup/Players/@advanced = 'yes'">s</xsl:if><xsl:text>: </xsl:text>
    <xsl:apply-templates select="Action" />
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Prestige" mode="player">
    <xsl:text>Prestige/Search action </xsl:text>
    <xsl:if test="./@actionUsed = 'yes'">[b][color=red]used[/color][/b]</xsl:if>
    <xsl:if test="./@actionUsed = 'no'">[b][color=green]available[/color][/b]</xsl:if>
    <xsl:if test="./@onTile"> - Has Prestige on the tile</xsl:if>
    <xsl:value-of select="$nl" />
    <xsl:text>Prestige: [b][color=purple]</xsl:text>
    <xsl:value-of select="." />
    <xsl:text> PP chip</xsl:text>
    <xsl:if test=". != 1">s</xsl:if>
    <xsl:text>[/color][/b] - </xsl:text>
  </xsl:template>

  <xsl:template match="Deck" mode="player">
    <xsl:value-of select="concat('Deck: ', ., ' card')" />
    <xsl:if test=". != 1">s</xsl:if>
    <xsl:text> - </xsl:text>
  </xsl:template>

  <xsl:template match="Discard" mode="player">
    <xsl:value-of select="concat('Discard: ', ., ' card')" />
    <xsl:if test=". != 1">s</xsl:if>
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Hand" mode="player">
    <xsl:value-of select="concat('Hand: [b]', @count, ' card')" />
    <xsl:if test="@count != 1">s</xsl:if>
    <xsl:text>[/b] - </xsl:text>
  </xsl:template>

  <xsl:template match="Chips" mode="player">
    <xsl:value-of select="concat('VP chips: [b][color=blue]', ., ' VP chip')" />
    <xsl:if test=". != 1">s</xsl:if>
    <xsl:text>[/color][/b] - </xsl:text>
  </xsl:template>

  <xsl:template match="Score" mode="player">
    <xsl:value-of select="concat('Points: [b]', ., ' VP')" />
    <xsl:if test=". != 1">s</xsl:if>
    <xsl:value-of select="concat('[/b]', $nl)" />
  </xsl:template>

  <xsl:template match="Goals" mode="player">
    <xsl:text>Goals claimed: </xsl:text>
    <xsl:if test="count(Goal) = 0">None</xsl:if>
    <xsl:apply-templates select="Goal" mode="names" />
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Tableau" mode="player">
    <xsl:if test="count(Card) = 0">No cards</xsl:if>
    <xsl:apply-templates select="Card" mode="images" />
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Saved" mode="player">
    <xsl:choose>
      <xsl:when test="count(Card) &gt; 0">
        <xsl:text>Saved:</xsl:text>
        <xsl:value-of select="$nl" />
        <xsl:apply-templates select="Card" mode="images" />
        <xsl:value-of select="$nl" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="concat('Saved ', @count, ' card')" />
        <xsl:if test="@count != 1">s</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Hand" mode="hand">
    <xsl:if test="count(Card[not(@explore)]) &gt; 0">
      <xsl:text>[b]Hand:[/b]</xsl:text>
      <xsl:value-of select="$nl" />
      <xsl:apply-templates select="*[not(@explore)]" mode="images" />
      <xsl:value-of select="$nl" />
    </xsl:if>
    <xsl:if test="count(Card[@explore]) &gt; 0">
      <xsl:text>Explore cards:</xsl:text>
      <xsl:value-of select="$nl" />
      <xsl:apply-templates select="*[@explore]" mode="images" />
      <xsl:value-of select="$nl" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="Start" mode="hand">
    <xsl:text>[b]Start worlds:[/b]</xsl:text>
      <xsl:value-of select="$nl" />
      <xsl:apply-templates mode="images" />
      <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Search" mode="hand">
    <xsl:text>[b]Search cards:[/b]</xsl:text>
      <xsl:value-of select="$nl" />
      <xsl:apply-templates mode="images" />
      <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Discards" mode="hand">
    <xsl:text>[b]Discarded cards:[/b]</xsl:text>
      <xsl:value-of select="$nl" />
      <xsl:apply-templates mode="images" />
      <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Flips" mode="hand">
    <xsl:text>[b]Gambling World cards:[/b]</xsl:text>
      <xsl:value-of select="$nl" />
      <xsl:apply-templates mode="images" />
      <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Status" mode="statusFooter">
    <xsl:text>[b]</xsl:text>
    <xsl:apply-templates select="Message" />
    <xsl:text>[/b]</xsl:text>
  </xsl:template>

  <xsl:template match="Log">
    <xsl:apply-templates />
    <xsl:value-of select="concat('======================', $nl)" />
  </xsl:template>

  <xsl:template match="Message" mode="statusHeader" />

  <xsl:template match="Message">
    <xsl:choose>
      <xsl:when test="@format = 'em'">[b]<xsl:value-of select="." />[/b]</xsl:when>
      <xsl:when test="@format = 'phase'">[color=#0000aa]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'takeover'">[color=#ff0000]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'goal'">[color=#eeaa00]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'prestige'">[color=#8800bb]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'verbose'">[color=#aaaaaa]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'discard'">[color=#aaaaaa]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'draw'">[color=#aaaaaa]<xsl:value-of select="." />[/color]</xsl:when>
      <xsl:when test="@format = 'chat'">[b]<xsl:value-of select="." />[/b]</xsl:when>
      <xsl:when test="@format = 'debug'">[bgcolor=#ff5555]<xsl:value-of select="." />[/bgcolor]</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$nl" />
  </xsl:template>

  <xsl:template match="Card" mode="names">
    <xsl:value-of select="." />
    <xsl:if test="@good"> (with good)</xsl:if>
    <xsl:if test="position() != last()"> - </xsl:if>
  </xsl:template>

  <xsl:template match="Card" mode="images">
    <xsl:variable name="id"><xsl:call-template name="cardId" /></xsl:variable>
    <xsl:value-of select="concat('[imageID=',$id,' inline]')" />
  </xsl:template>

  <xsl:template match="Goal" mode="names">
    <xsl:text>[b][color=</xsl:text>
    <xsl:choose>
      <xsl:when test="@claimed = 'yes'">gray</xsl:when>
      <xsl:when test="@shared = 'yes'">gray</xsl:when>
      <xsl:otherwise>orange</xsl:otherwise>
    </xsl:choose>
    <xsl:text>]</xsl:text>
    <xsl:call-template name="goalDesc" />
    <xsl:text>[/color][/b]</xsl:text>
    <xsl:if test="position() != last()"> - </xsl:if>
  </xsl:template>

  <xsl:template match="Goal" mode="images">
    <xsl:variable name="id"><xsl:call-template name="goalId" /></xsl:variable>
    <xsl:value-of select="concat('[imageID=',$id,' inline]')" />
  </xsl:template>

  <xsl:template name="goalDesc">
    <xsl:choose>
      <xsl:when test=". = 'Galactic Standard of Living'">First 5 VP chips</xsl:when>
      <xsl:when test=". = 'System Diversity'">First all kinds</xsl:when>
      <xsl:when test=". = 'Overlord Discoveries'">First 3 Alien</xsl:when>
      <xsl:when test=". = 'Budget Surplus'">First discard at end of round</xsl:when>
      <xsl:when test=". = 'Innovation Leader'">First Power in all phases</xsl:when>
      <xsl:when test=". = 'Galactic Status'">First 6?-development</xsl:when>
      <xsl:when test=". = 'Uplift Knowledge'">First 3 Uplift</xsl:when>
      <xsl:when test=". = 'Galactic Riches'">First 4 goods</xsl:when>
      <xsl:when test=". = 'Expansion Leader'">First 8 cards</xsl:when>
      <xsl:when test=". = 'Peace/War Leader'">First negative Military &amp; 2 worlds / a takeover attack power &amp; 2 Military worlds</xsl:when>
      <xsl:when test=". = 'Galactic Standing'">First 2 prestige chips and 3 VP chips</xsl:when>
      <xsl:when test=". = 'Military Influence'">First 3 Imperium cards / 4 Military worlds</xsl:when>
      <xsl:when test=". = 'Greatest Military'">Most total military (6+)</xsl:when>
      <xsl:when test=". = 'Largest Industry'">Most Novelty and/or Rare worlds (3+)</xsl:when>
      <xsl:when test=". = 'Greatest Infrastructure'">Most developments (4+)</xsl:when>
      <xsl:when test=". = 'Production Leader'">Most production worlds (4+)</xsl:when>
      <xsl:when test=". = 'Research Leader'">Most Explore powers (3+)</xsl:when>
      <xsl:when test=". = 'Propaganda Edge'">Most Rebel Military worlds (3+)</xsl:when>
      <xsl:when test=". = 'Galactic Prestige'">Most prestige chips (3+)</xsl:when>
      <xsl:when test=". = 'Prosperity Lead'">Most Consume powers (3+)</xsl:when>
      <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="goalId">
    <xsl:choose>
      <xsl:when test=". = 'Galactic Standard of Living'">451487</xsl:when>
      <xsl:when test=". = 'System Diversity'">451489</xsl:when>
      <xsl:when test=". = 'Overlord Discoveries'">451490</xsl:when>
      <xsl:when test=". = 'Budget Surplus'">451491</xsl:when>
      <xsl:when test=". = 'Innovation Leader'">451485</xsl:when>
      <xsl:when test=". = 'Galactic Status'">451488</xsl:when>
      <xsl:when test=". = 'Uplift Knowledge'">743455</xsl:when>
      <xsl:when test=". = 'Galactic Riches'">743459</xsl:when>
      <xsl:when test=". = 'Expansion Leader'">743464</xsl:when>
      <xsl:when test=". = 'Peace/War Leader'">743454</xsl:when>
      <xsl:when test=". = 'Galactic Standing'">743456</xsl:when>
      <xsl:when test=". = 'Military Influence'">743463</xsl:when>
      <xsl:when test=". = 'Greatest Military'">451477</xsl:when>
      <xsl:when test=". = 'Largest Industry'">451484</xsl:when>
      <xsl:when test=". = 'Greatest Infrastructure'">451481</xsl:when>
      <xsl:when test=". = 'Production Leader'">451476</xsl:when>
      <xsl:when test=". = 'Research Leader'">743458</xsl:when>
      <xsl:when test=". = 'Propaganda Edge'">743462</xsl:when>
      <xsl:when test=". = 'Galactic Prestige'">743460</xsl:when>
      <xsl:when test=". = 'Prosperity Lead'">743461</xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="cardId">
    <xsl:choose>
      <xsl:when test="not(@good)">
        <xsl:choose>
          <xsl:when test=". = 'Abandoned Alien Uplift Camp'">524250</xsl:when>
          <xsl:when test=". = 'Alien Booby Trap'">756231</xsl:when>
          <xsl:when test=". = 'Alien Burial Site'">756230</xsl:when>
          <xsl:when test=". = 'Alien Cornucopia'">756228</xsl:when>
          <xsl:when test=". = 'Alien Data Repository'">524248</xsl:when>
          <xsl:when test=". = 'Alien Departure Point'">756227</xsl:when>
          <xsl:when test=". = 'Alien Guardian'">756225</xsl:when>
          <xsl:when test=". = 'Alien Monolith'">524246</xsl:when>
          <xsl:when test=". = 'Alien Oort Cloud Refinery'">756223</xsl:when>
          <xsl:when test=". = 'Alien Research Team'">756217</xsl:when>
          <xsl:when test=". = 'Alien Robot Scout Ship'">340998</xsl:when>
          <xsl:when test=". = 'Alien Robot Sentry'">354962</xsl:when>
          <xsl:when test=". = 'Alien Robotic Factory'">353147</xsl:when>
          <xsl:when test=". = 'Alien Rosetta Stone World'">340487</xsl:when>
          <xsl:when test=". = 'Alien Tech Institute'">354518</xsl:when>
          <xsl:when test=". = 'Alien Tourist Attraction'">756216</xsl:when>
          <xsl:when test=". = 'Alien Toy Shop'">451464</xsl:when>
          <xsl:when test=". = 'Alien Uplift Center'">524244</xsl:when>
          <xsl:when test=". = 'Alpha Centauri'">340437</xsl:when>
          <xsl:when test=". = 'Ancient Race'">451465</xsl:when>
          <xsl:when test=". = 'Aquatic Uplift Race'">357389</xsl:when>
          <xsl:when test=". = 'Artist Colony'">356855</xsl:when>
          <xsl:when test=". = 'Asteroid Belt'">356809</xsl:when>
          <xsl:when test=". = 'Avian Uplift Race'">357619</xsl:when>
          <xsl:when test=". = 'Bio-Hazard Mining World'">353127</xsl:when>
          <xsl:when test=". = 'Black Hole Miners'">756215</xsl:when>
          <xsl:when test=". = 'Black Market Trading World'">356849</xsl:when>
          <xsl:when test=". = 'Blaster Gem Mines'">341377</xsl:when>
          <xsl:when test=". = 'Blaster Runners'">524243</xsl:when>
          <xsl:when test=". = 'Clandestine Uplift Lab'">451449</xsl:when>
          <xsl:when test=". = 'Colony Ship'">341705</xsl:when>
          <xsl:when test=". = 'Comet Zone'">356850</xsl:when>
          <xsl:when test=". = 'Consumer Markets'">354516</xsl:when>
          <xsl:when test=". = 'Contact Specialist'">340758</xsl:when>
          <xsl:when test=". = 'Damaged Alien Factory'">451448</xsl:when>
          <xsl:when test=". = 'Deficit Spending'">340443</xsl:when>
          <xsl:when test=". = 'Deserted Alien Colony'">357618</xsl:when>
          <xsl:when test=". = 'Deserted Alien Library'">340909</xsl:when>
          <xsl:when test=". = 'Deserted Alien Outpost'">353881</xsl:when>
          <xsl:when test=". = 'Deserted Alien World'">451452</xsl:when>
          <xsl:when test=". = 'Destroyed World'">341712</xsl:when>
          <xsl:when test=". = 'Devolved Uplift Race'">524241</xsl:when>
          <xsl:when test=". = 'Distant World'">357386</xsl:when>
          <xsl:when test=". = 'Diversified Economy'">340438</xsl:when>
          <xsl:when test=". = 'Doomed World'">451427</xsl:when>
          <xsl:when test=". = 'Drop Ships'">340474</xsl:when>
          <xsl:when test=". = 'Dying Colony'">524239</xsl:when>
          <xsl:when test="contains(., 'Lost Colony')">340462</xsl:when>
          <xsl:when test=". = 'Empath World'">341381</xsl:when>
          <xsl:when test=". = 'Epsilon Eridani'">340439</xsl:when>
          <xsl:when test=". = 'Expanding Colony'">357384</xsl:when>
          <xsl:when test=". = 'Expedition Force'">340442</xsl:when>
          <xsl:when test=". = 'Export Duties'">340912</xsl:when>
          <xsl:when test=". = 'Federation Capital'">756214</xsl:when>
          <xsl:when test=". = 'Former Penal Colony'">357620</xsl:when>
          <xsl:when test=". = 'Free Trade Association'">356848</xsl:when>
          <xsl:when test=". = 'Galactic Advertisers'">524238</xsl:when>
          <xsl:when test=". = 'Galactic Bankers'">524237</xsl:when>
          <xsl:when test=". = 'Galactic Bazaar'">451457</xsl:when>
          <xsl:when test=". = 'Galactic Developers'">524236</xsl:when>
          <xsl:when test=". = 'Galactic Engineers'">340486</xsl:when>
          <xsl:when test=". = 'Galactic Exchange'">524235</xsl:when>
          <xsl:when test=". = 'Galactic Federation'">356847</xsl:when>
          <xsl:when test=". = 'Galactic Genome Project'">451438</xsl:when>
          <xsl:when test=". = 'Galactic Imperium'">356852</xsl:when>
          <xsl:when test=". = 'Galactic Markets'">756213</xsl:when>
          <xsl:when test=". = 'Galactic Power Brokers'">756212</xsl:when>
          <xsl:when test=". = 'Galactic Renaissance'">340468</xsl:when>
          <xsl:when test=". = 'Galactic Resort'">341380</xsl:when>
          <xsl:when test=". = 'Galactic Salon'">524234</xsl:when>
          <xsl:when test=". = 'Galactic Scavengers'">756211</xsl:when>
          <xsl:when test=". = 'Galactic Studios'">451458</xsl:when>
          <xsl:when test=". = 'Galactic Survey: SETI'">354517</xsl:when>
          <xsl:when test=". = 'Galactic Trendsetters'">341379</xsl:when>
          <xsl:when test=". = 'Gambling World'">524233</xsl:when>
          <xsl:when test=". = 'Gem Smugglers'">524231</xsl:when>
          <xsl:when test=". = 'Gem World'">340440</xsl:when>
          <xsl:when test=". = 'Gene Designers'">524229</xsl:when>
          <xsl:when test=". = 'Genetics Lab'">340760</xsl:when>
          <xsl:when test=". = 'Golden Age of Terraforming'">756209</xsl:when>
          <xsl:when test=". = 'Hidden Fortress'">524228</xsl:when>
          <xsl:when test=". = 'Hive World'">451460</xsl:when>
          <xsl:when test=". = 'Imperium Armaments World'">340465</xsl:when>
          <xsl:when test=". = 'Imperium Blaster Gem Consortium'">524226</xsl:when>
          <xsl:when test=". = 'Imperium Capital'">756208</xsl:when>
          <xsl:when test=". = 'Imperium Cloaking Technology'">524225</xsl:when>
          <xsl:when test=". = 'Imperium Fuel Depot'">756207</xsl:when>
          <xsl:when test=". = 'Imperium Invasion Fleet'">756205</xsl:when>
          <xsl:when test=". = 'Imperium Lords'">451441</xsl:when>
          <xsl:when test=". = 'Imperium Planet Buster'">756204</xsl:when>
          <xsl:when test=". = 'Imperium Seat'">524224</xsl:when>
          <xsl:when test=". = 'Imperium Troops'">524223</xsl:when>
          <xsl:when test=". = 'Imperium Warlord'">524222</xsl:when>
          <xsl:when test=". = 'Improved Logistics'">451444</xsl:when>
          <xsl:when test=". = 'Information Hub'">756203</xsl:when>
          <xsl:when test=". = 'Insect Uplift Race'">524220</xsl:when>
          <xsl:when test=". = 'Interstellar Bank'">341709</xsl:when>
          <xsl:when test=". = 'Interstellar Casus Belli'">756201</xsl:when>
          <xsl:when test=". = 'Interstellar Prospectors'">524219</xsl:when>
          <xsl:when test=". = 'Investment Credits'">356836</xsl:when>
          <xsl:when test=". = 'Lifeforms, Inc'">756200</xsl:when>
          <xsl:when test=". = 'Lost Alien Battle Fleet'">357387</xsl:when>
          <xsl:when test=". = 'Lost Alien Warship'">357607</xsl:when>
          <xsl:when test=". = 'Lost Species Ark World'">340453</xsl:when>
          <xsl:when test=". = 'Malevolent Lifeforms'">340761</xsl:when>
          <xsl:when test=". = 'Mercenary Fleet'">524217</xsl:when>
          <xsl:when test=". = 'Merchant Guild'">341376</xsl:when>
          <xsl:when test=". = 'Merchant World'">340911</xsl:when>
          <xsl:when test=". = 'Mining Conglomerate'">340490</xsl:when>
          <xsl:when test=". = 'Mining League'">341710</xsl:when>
          <xsl:when test=". = 'Mining Mole Uplift Race'">756198</xsl:when>
          <xsl:when test=". = 'Mining Robots'">354961</xsl:when>
          <xsl:when test=". = 'Mining World'">353148</xsl:when>
          <xsl:when test=". = 'New Earth'">353133</xsl:when>
          <xsl:when test=". = 'New Economy'">340466</xsl:when>
          <xsl:when test=". = 'New Galactic Order'">340904</xsl:when>
          <xsl:when test=". = 'New Military Tactics'">340753</xsl:when>
          <xsl:when test=". = 'New Sparta'">353124</xsl:when>
          <xsl:when test=". = 'New Survivalists'">341713</xsl:when>
          <xsl:when test=". = 'New Vinland'">340469</xsl:when>
          <xsl:when test=". = 'Old Earth'">340450</xsl:when>
          <xsl:when test=". = 'Outlaw World'">356833</xsl:when>
          <xsl:when test=". = 'Pan-Galactic Affluence'">756196</xsl:when>
          <xsl:when test=". = 'Pan-Galactic Hologrid'">756195</xsl:when>
          <xsl:when test=". = 'Pan-Galactic League'">356846</xsl:when>
          <xsl:when test=". = 'Pan-Galactic Mediator'">756194</xsl:when>
          <xsl:when test=". = 'Pan-Galactic Research'">524216</xsl:when>
          <xsl:when test=". = 'Pan-Galactic Security Council'">756193</xsl:when>
          <xsl:when test=". = 'Pilgrimage World'">340755</xsl:when>
          <xsl:when test=". = 'Pirate World'">341092</xsl:when>
          <xsl:when test=". = 'Plague World'">340451</xsl:when>
          <xsl:when test=". = 'Pre-Sentient Race'">341744</xsl:when>
          <xsl:when test=". = 'Primitive Rebel World'">524214</xsl:when>
          <xsl:when test=". = 'Prospecting Guild'">524213</xsl:when>
          <xsl:when test=". = 'Prosperous World'">357388</xsl:when>
          <xsl:when test=". = 'Psi-Crystal World'">756192</xsl:when>
          <xsl:when test=". = 'Public Works'">341095</xsl:when>
          <xsl:when test=". = 'R&amp;D Crash Program'">524212</xsl:when>
          <xsl:when test=". = 'Radioactive World'">354529</xsl:when>
          <xsl:when test=". = 'Ravaged Uplift World'">756190</xsl:when>
          <xsl:when test=". = 'Rebel Alliance'">524211</xsl:when>
          <xsl:when test=". = 'Rebel Base'">356854</xsl:when>
          <xsl:when test=". = 'Rebel Cantina'">524210</xsl:when>
          <xsl:when test=". = 'Rebel Colony'">451430</xsl:when>
          <xsl:when test=". = 'Rebel Convict Mines'">524208</xsl:when>
          <xsl:when test=". = 'Rebel Council'">756188</xsl:when>
          <xsl:when test=". = 'Rebel Freedom Fighters'">756187</xsl:when>
          <xsl:when test=". = 'Rebel Fuel Cache'">341096</xsl:when>
          <xsl:when test=". = 'Rebel Fuel Refinery'">756186</xsl:when>
          <xsl:when test=". = 'Rebel Homeworld'">341094</xsl:when>
          <xsl:when test=". = 'Rebel Miners'">356851</xsl:when>
          <xsl:when test=". = 'Rebel Outpost'">356853</xsl:when>
          <xsl:when test=". = 'Rebel Pact'">524206</xsl:when>
          <xsl:when test=". = 'Rebel Sneak Attack'">756184</xsl:when>
          <xsl:when test=". = 'Rebel Stronghold'">524205</xsl:when>
          <xsl:when test=". = 'Rebel Sympathizers'">451454</xsl:when>
          <xsl:when test=". = 'Rebel Troops'">756183</xsl:when>
          <xsl:when test=". = 'Rebel Underground'">354958</xsl:when>
          <xsl:when test=". = 'Rebel Warrior Race'">353882</xsl:when>
          <xsl:when test=". = 'Refugee World'">341093</xsl:when>
          <xsl:when test=". = 'Replicant Robots'">340994</xsl:when>
          <xsl:when test=". = 'Reptilian Uplift Race'">353885</xsl:when>
          <xsl:when test=". = 'Research Labs'">340449</xsl:when>
          <xsl:when test=". = 'Retrofit &amp; Salvage, Inc'">756182</xsl:when>
          <xsl:when test=". = 'Runaway Robots'">354957</xsl:when>
          <xsl:when test=". = 'Secluded World'">353883</xsl:when>
          <xsl:when test=". = 'Separatist Colony'">451424</xsl:when>
          <xsl:when test=". = 'Smuggling Lair'">451455</xsl:when>
          <xsl:when test=". = 'Smuggling World'">524203</xsl:when>
          <xsl:when test=". = 'Space Marines'">340446</xsl:when>
          <xsl:when test=". = 'Space Mercenaries'">451433</xsl:when>
          <xsl:when test=". = 'Space Port'">356379</xsl:when>
          <xsl:when test=". = 'Spice World'">341378</xsl:when>
          <xsl:when test=". = 'Star Nomad Lair'">353130</xsl:when>
          <xsl:when test=". = 'Terraformed World'">340452</xsl:when>
          <xsl:when test=". = 'Terraforming Engineers'">756180</xsl:when>
          <xsl:when test=". = 'Terraforming Guild'">451435</xsl:when>
          <xsl:when test=". = 'Terraforming Robots'">340906</xsl:when>
          <xsl:when test=". = 'The Last of the Uplift Gnarssh'">357610</xsl:when>
          <xsl:when test=". = 'Tourist World'">340464</xsl:when>
          <xsl:when test=". = 'Trade League'">340448</xsl:when>
          <xsl:when test=". = 'Trading Outpost'">524202</xsl:when>
          <xsl:when test=". = 'Universal Exports'">756179</xsl:when>
          <xsl:when test=". = 'Universal Peace Institute'">756177</xsl:when>
          <xsl:when test=". = 'Universal Symbionts'">524200</xsl:when>
          <xsl:when test=". = 'Uplift Code'">524198</xsl:when>
          <xsl:when test=". = 'Uplift Gene Breeders'">756176</xsl:when>
          <xsl:when test=". = 'Uplift Mercenary Force'">756174</xsl:when>
          <xsl:when test=". = 'Uplift Revolt World'">756173</xsl:when>
          <xsl:when test=". = 'Volcanic World'">451456</xsl:when>

          <xsl:when test=". = 'Alien Research Ship'">1902420</xsl:when>
          <xsl:when test=". = 'Alien Survey Technology'">1896652</xsl:when>
          <xsl:when test=". = 'Galactic Investors'">1902458</xsl:when>
          <xsl:when test=". = 'Imperium Stealth Tactics'">1894951</xsl:when>
          <xsl:when test=". = 'Imperium Supply Convoy'">1896646</xsl:when>
          <xsl:when test=". = 'Scientific Cruisers'">1902418</xsl:when>
          <xsl:when test=". = 'Terraforming Project'">1897486</xsl:when>
          <xsl:when test=". = 'Alien Artifact Hunters'">1896681</xsl:when>
          <xsl:when test=". = 'Alien Fuel Refinery'">1902466</xsl:when>
          <xsl:when test=". = 'Alien Sentinels'">1902464</xsl:when>
          <xsl:when test=". = 'Alien Uplift Chamber'">1902416</xsl:when>
          <xsl:when test=". = 'Amphibian Uplift Race'">1902462</xsl:when>
          <xsl:when test=". = 'Arboreal Uplift Race'">1902460</xsl:when>
          <xsl:when test=". = 'Deep Space Symbionts, Ltd.'">1902423</xsl:when>
          <xsl:when test=". = 'Designer Species, Ultd.'">1896661</xsl:when>
          <xsl:when test=". = 'Frontier Capital'">1896682</xsl:when>
          <xsl:when test=". = 'Galactic News Hub'">1902417</xsl:when>
          <xsl:when test=". = 'Galactic Survey Headquarters'">1902457</xsl:when>
          <xsl:when test=". = 'Imperium Blaster Gem Depot'">1902455</xsl:when>
          <xsl:when test=". = 'Imperium Fifth Column'">1902422</xsl:when>
          <xsl:when test=". = 'Interstellar Trade Port'">1902477</xsl:when>
          <xsl:when test=". = 'Jumpdrive Fuel Refinery'">1902476</xsl:when>
          <xsl:when test=". = 'Mercenary Guild'">1902475</xsl:when>
          <xsl:when test=". = 'Ore-Rich World'">1902474</xsl:when>
          <xsl:when test=". = 'Rebel Gem Smugglers'">1902473</xsl:when>
          <xsl:when test=". = 'Rebel Mutineers'">1896685</xsl:when>
          <xsl:when test=". = 'Rebel Resistance'">1902415</xsl:when>
          <xsl:when test=". = 'Rebel Uplift World'">1902421</xsl:when>
          <xsl:when test=". = 'Self-Repairing Alien Artillery'">1902472</xsl:when>
          <xsl:when test=". = 'Sentient Robots'">1894953</xsl:when>
          <xsl:when test=". = 'Terraforming Colony'">1902470</xsl:when>
          <xsl:when test=". = 'Tranship Point'">1902468</xsl:when>
          <xsl:when test=". = 'Uplift Researchers'">1896684</xsl:when>
          <xsl:when test=". = 'Alien Researchers'">1902453</xsl:when>
          <xsl:when test=". = 'Galactic Expansionists'">1902459</xsl:when>
          <xsl:when test=". = 'Imperium War Faction'">1902414</xsl:when>
          <xsl:when test=". = 'Terraforming Unlimited'">1902413</xsl:when>
          <xsl:when test=". = 'Uplift Alliance'">1902454</xsl:when>
          <xsl:when test=". = 'Wormhole Prospectors'">1902467</xsl:when>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test=". = 'Alien Burial Site'">756229</xsl:when>
          <xsl:when test=". = 'Alien Data Repository'">524249</xsl:when>
          <xsl:when test=". = 'Alien Departure Point'">756226</xsl:when>
          <xsl:when test=". = 'Alien Guardian'">756224</xsl:when>
          <xsl:when test=". = 'Alien Monolith'">524247</xsl:when>
          <xsl:when test=". = 'Alien Oort Cloud Refinery'">756218</xsl:when>
          <xsl:when test=". = 'Alien Oort Cloud Refinery'">756222</xsl:when>
          <xsl:when test=". = 'Alien Oort Cloud Refinery'">756221</xsl:when>
          <xsl:when test=". = 'Alien Oort Cloud Refinery'">756220</xsl:when>
          <xsl:when test=". = 'Alien Oort Cloud Refinery'">756219</xsl:when>
          <xsl:when test=". = 'Alien Robot Scout Ship'">357631</xsl:when>
          <xsl:when test=". = 'Alien Robot Sentry'">357383</xsl:when>
          <xsl:when test=". = 'Alien Robotic Factory'">357651</xsl:when>
          <xsl:when test=". = 'Alien Tourist Attraction'">757909</xsl:when>
          <xsl:when test=". = 'Alien Toy Shop'">451469</xsl:when>
          <xsl:when test=". = 'Alien Uplift Center'">524245</xsl:when>
          <xsl:when test=". = 'Alpha Centauri'">341384</xsl:when>
          <xsl:when test=". = 'Ancient Race'">451468</xsl:when>
          <xsl:when test=". = 'Aquatic Uplift Race'">357642</xsl:when>
          <xsl:when test=". = 'Artist Colony'">357655</xsl:when>
          <xsl:when test=". = 'Asteroid Belt'">357600</xsl:when>
          <xsl:when test=". = 'Avian Uplift Race'">357622</xsl:when>
          <xsl:when test=". = 'Bio-Hazard Mining World'">357650</xsl:when>
          <xsl:when test=". = 'Blaster Gem Mines'">357636</xsl:when>
          <xsl:when test=". = 'Comet Zone'">357660</xsl:when>
          <xsl:when test=". = 'Damaged Alien Factory'">451473</xsl:when>
          <xsl:when test=". = 'Deserted Alien Colony'">357629</xsl:when>
          <xsl:when test=". = 'Deserted Alien Library'">341373</xsl:when>
          <xsl:when test=". = 'Deserted Alien Outpost'">354244</xsl:when>
          <xsl:when test=". = 'Destroyed World'">357637</xsl:when>
          <xsl:when test=". = 'Devolved Uplift Race'">524242</xsl:when>
          <xsl:when test=". = 'Distant World'">357656</xsl:when>
          <xsl:when test=". = 'Dying Colony'">524240</xsl:when>
          <xsl:when test="contains(., 'Lost Colony')">341387</xsl:when>
          <xsl:when test=". = 'Empath World'">357632</xsl:when>
          <xsl:when test=". = 'Former Penal Colony'">357630</xsl:when>
          <xsl:when test=". = 'Galactic Bazaar'">451466</xsl:when>
          <xsl:when test=". = 'Galactic Resort'">357644</xsl:when>
          <xsl:when test=". = 'Galactic Scavengers'">756210</xsl:when>
          <xsl:when test=". = 'Galactic Studios'">451463</xsl:when>
          <xsl:when test=". = 'Gem Smugglers'">524232</xsl:when>
          <xsl:when test=". = 'Gem World'">341386</xsl:when>
          <xsl:when test=". = 'Gene Designers'">524230</xsl:when>
          <xsl:when test=". = 'Hive World'">451467</xsl:when>
          <xsl:when test=". = 'Imperium Armaments World'">357663</xsl:when>
          <xsl:when test=". = 'Imperium Blaster Gem Consortium'">524227</xsl:when>
          <xsl:when test=". = 'Imperium Fuel Depot'">756206</xsl:when>
          <xsl:when test=". = 'Information Hub'">756202</xsl:when>
          <xsl:when test=". = 'Insect Uplift Race'">524221</xsl:when>
          <xsl:when test=". = 'Interstellar Prospectors'">639052</xsl:when>
          <xsl:when test=". = 'Lifeforms, Inc'">756199</xsl:when>
          <xsl:when test=". = 'Lost Alien Battle Fleet'">357653</xsl:when>
          <xsl:when test=". = 'Lost Alien Warship'">357635</xsl:when>
          <xsl:when test=". = 'Lost Species Ark World'">341374</xsl:when>
          <xsl:when test=". = 'Malevolent Lifeforms'">369685</xsl:when>
          <xsl:when test=". = 'Mining Mole Uplift Race'">756197</xsl:when>
          <xsl:when test=". = 'Mining World'">357648</xsl:when>
          <xsl:when test=". = 'New Earth'">357654</xsl:when>
          <xsl:when test=". = 'New Survivalists'">369686</xsl:when>
          <xsl:when test=". = 'New Vinland'">340491</xsl:when>
          <xsl:when test=". = 'Pirate World'">357647</xsl:when>
          <xsl:when test=". = 'Plague World'">357657</xsl:when>
          <xsl:when test=". = 'Pre-Sentient Race'">357623</xsl:when>
          <xsl:when test=". = 'Primitive Rebel World'">524215</xsl:when>
          <xsl:when test=". = 'Prosperous World'">369689</xsl:when>
          <xsl:when test=". = 'Psi-Crystal World'">756191</xsl:when>
          <xsl:when test=". = 'Radioactive World'">357624</xsl:when>
          <xsl:when test=". = 'Ravaged Uplift World'">756189</xsl:when>
          <xsl:when test=". = 'Rebel Convict Mines'">524209</xsl:when>
          <xsl:when test=". = 'Rebel Fuel Cache'">341506</xsl:when>
          <xsl:when test=". = 'Rebel Fuel Refinery'">756185</xsl:when>
          <xsl:when test=". = 'Rebel Miners'">357652</xsl:when>
          <xsl:when test=". = 'Rebel Sympathizers'">451475</xsl:when>
          <xsl:when test=". = 'Rebel Warrior Race'">357634</xsl:when>
          <xsl:when test=". = 'Refugee World'">357649</xsl:when>
          <xsl:when test=". = 'Reptilian Uplift Race'">354243</xsl:when>
          <xsl:when test=". = 'Retrofit &amp; Salvage, Inc'">756181</xsl:when>
          <xsl:when test=". = 'Runaway Robots'">357621</xsl:when>
          <xsl:when test=". = 'Secluded World'">357662</xsl:when>
          <xsl:when test=". = 'Smuggling Lair'">451472</xsl:when>
          <xsl:when test=". = 'Smuggling World'">524204</xsl:when>
          <xsl:when test=". = 'Space Port'">357385</xsl:when>
          <xsl:when test=". = 'Spice World'">357658</xsl:when>
          <xsl:when test=". = 'Star Nomad Lair'">357628</xsl:when>
          <xsl:when test=". = 'The Last of the Uplift Gnarssh'">357633</xsl:when>
          <xsl:when test=". = 'Universal Exports'">756178</xsl:when>
          <xsl:when test=". = 'Universal Symbionts'">524201</xsl:when>
          <xsl:when test=". = 'Uplift Gene Breeders'">756175</xsl:when>
          <xsl:when test=". = 'Uplift Revolt World'">756172</xsl:when>
          <xsl:when test=". = 'Volcanic World'">451470</xsl:when>

          <xsl:when test=". = 'Alien Fuel Refinery'">1902564</xsl:when>
          <xsl:when test=". = 'Alien Sentinels'">1902565</xsl:when>
          <xsl:when test=". = 'Alien Uplift Chamber'">1902554</xsl:when>
          <xsl:when test=". = 'Amphibian Uplift Race'">1902566</xsl:when>
          <xsl:when test=". = 'Arboreal Uplift Race'">1902567</xsl:when>
          <xsl:when test=". = 'Deep Space Symbionts, Ltd.'">1902553</xsl:when>
          <xsl:when test=". = 'Designer Species, Ultd.'">1902552</xsl:when>
          <xsl:when test=". = 'Galactic News Hub'">1902551</xsl:when>
          <xsl:when test=". = 'Galactic Survey Headquarters'">1902568</xsl:when>
          <xsl:when test=". = 'Imperium Blaster Gem Depot'">1902548</xsl:when>
          <xsl:when test=". = 'Interstellar Trade Port'">1902563</xsl:when>
          <xsl:when test=". = 'Jumpdrive Fuel Refinery'">1902562</xsl:when>
          <xsl:when test=". = 'Mercenary Guild'">1902561</xsl:when>
          <xsl:when test=". = 'Ore-Rich World'">1902559</xsl:when>
          <xsl:when test=". = 'Rebel Gem Smugglers'">1902558</xsl:when>
          <xsl:when test=". = 'Rebel Mutineers'">1902550</xsl:when>
          <xsl:when test=". = 'Self-Repairing Alien Artillery'">1902557</xsl:when>
          <xsl:when test=". = 'Terraforming Colony'">1902556</xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
