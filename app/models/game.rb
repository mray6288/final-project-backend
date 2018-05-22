class Game < ApplicationRecord

	@@targets = ['apple','bowtie','circle','hexagon','sword','watermelon','dog','foot',
	  'butterfly','chair','clock','fish','door','pizza','television','sun',
	  'mushroom','eye','hockey stick','dumbbell','shoe','stop sign',
	  'snowman','snowflake','table','tooth','saxophone','star','boomerang','broom',
	  'baseball','baseball bat','golf club']

	def set_target
		self.target = @@targets.sample
		self.save()
	end

end
